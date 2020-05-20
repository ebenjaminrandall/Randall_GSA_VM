function outputs = tvSob(nsamples,bounds,data,varargin)
%{
This code computes the scalar and time-varying Sobol' indices. 

Inputs: 
    nsamples:   integer for number of sample points taken from space.
    bounds:     [(lower bounds) (upper bound)] is a p x 2 matrix. 
    data:       structure containing all extra arguments for model_sol.m 
                If the quantity of interest (QoI) is a time-varying
                quantity, then the structure "data" must have a "time" as a
                field. 
    varargin:   contains the following options 
        'parallelComp' - can turn 'on'. Default set to 'off' 

Output:
    outputs:    structure including scalar and time-varying Sobol' indices
                and the parameter variances 

This function calls model_sol_GSA.m which is a function that evaluates your 
model of the form 
    QoI = model_sol_GSA(pars,data)
where 
    pars:       parameter vector upon which to evaluate the model  
    data:       a structure for all of the other inputs for model_sol
    QoI:        Quantity of interest (can be scalar or time-varying)
%} 

% Check inputs
if nargin < 4
    parallel = 0;
    if nargin < 3
        data = [];
        if nargin < 2
            error('Not enough inputs')
        end
    end
end

if nargin > 3
    n = length(varargin);
    if rem(n,2) ~= 0
        error('Property name and value mismatch')
    end
    
    if n > 4
        error('Too many inputs')
    end
    
    propNames = {'parallelComp'};
             
    i = 1;
    parDone = 0;
    while i <= n
        arg = varargin{i};
        if ~ischar(arg)
                error('Property names must be strings.')
        end
        
        j = strcmpi(arg, propNames);
        if sum(j) == 0
            error('Invalid property name')
        end
        arg2 = varargin{i+1};
        if j(1) == 1
            if ~isinteger(arg2) && arg2 < 0
                error('Value for Parallel Computing must be a scalar value greater than 0.')
            end
            if arg2 == 0
                parallel = 0;
            else
                parallel = 1;
                parCores = arg2;
                parDone = 1; 
            end
        elseif parDone == 0
            parallel = 0;
        end
        
        i = i+2;
    end
end
        
lb = bounds(:,1);
ub = bounds(:,2); 

p = length(lb);

%% Parallel computing option

if parallel 
    pool = gcp('nocreate');
    if isempty(pool)
        parpool([2, parCores]);
    end
end
    
%% Sample parameter space 

%Generate Sobol' set in base-2
Sob = sobolset(2*p);
Sob = scramble(Sob, 'MatousekAffineOwen');

%Sampling matrices 
M = nsamples;
A = ones(M,p)*diag(lb) + Sob(1:M,1:p)*diag(ub-lb);
B = ones(M,p)*diag(lb) + Sob(1:M,p+1:end)*diag(ub-lb);
C = [A;B];

%% Generate A_i matrix by interchanging columns

Ai = ones(M*p, p);
for i = 1:p
    Ai(M*(i-1)+1:i*M,:) = A;
    Ai(M*(i-1)+1:i*M,i) = B(:,i);
end 

%% Evaluate function over the rows of C and Ai 

% Solve model initially 
initsoln = model_wrap_GSA(C(1,:),data); 
if length(initsoln) == 1
    scalar = 1; 
    fC_sca = ones(2*M,1);
    fAi_sca = ones(M*p,1);
    fC_sca(1) = initsoln;
else
    scalar = 0;
    if ~isfield(data, 'time')
        error('Your solution is a vector. Please include a "time" field containing the corresponding time vector in the data structure.')
    end
    time = data.time;
    
    [r,c] = size(initsoln);
    if r>c
        column = 1;
        initsoln = initsoln';
    end    
    fC_gen  = ones(2*M, length(time));
    fC_sca  = ones(2*M,1);
    fAi_gen = ones(M*p, length(time));
    fAi_sca = ones(M*p,1);
    fC_gen(1,:) = initsoln;
    fC_sca(1) = norm(fC_gen(1,:));
end

% Solve the model the rest of the way

if parallel %Only if 'parallel' is 'on'
    parfor i = 2:2*M

        %Solve model 
        s_C = model_wrap_GSA(C(i,:),data); 
        sol_C = s_C; 
        
        if scalar
            fC_sca(i)   = sol_C;
        else
            if column
                sol_C   = sol_C';
            end
            fC_gen(i,:) = sol_C;
            fC_sca(i)   = norm(fC_gen(i,:)); 
        end
    end

    parfor i = 1:M*p

        % Solve model 
        s_Ai = model_wrap_GSA(Ai(i,:),data); 
        sol_Ai = s_Ai; 
        
        if scalar
            fAi_sca(i)   = sol_Ai; 
        else 
            if column
                sol_Ai   = sol_Ai';
            end
            fAi_gen(i,:) = sol_Ai;
            fAi_sca(i)   = norm(fAi_gen(i,:)); 
        end 
    end
else 
    for i = 2:2*M
        %Solve model 
        sol_C = model_wrap_GSA(C(i,:),data); 
        
        if scalar
            fC_sca(i) = sol_C;  
        else 
            if column
                sol_C = sol_C';
            end
            fC_gen(i,:) = sol_C;
            fC_sca(i)   = norm(fC_gen(i,:));  
        end 
    end

    for i = 1:M*p
        % Solve model  
        sol_Ai = model_wrap_GSA(Ai(i,:),data); 
        
        if scalar
            fAi_sca(i)   = sol_Ai; 
        else 
            if column
                sol_Ai = sol_Ai';
            end
            fAi_gen(i,:) = sol_Ai;
            fAi_sca(i)   = norm(fAi_gen(i,:)); 
        end 
    end
end 

%% Determine time-varying variances 

fA_sca = fC_sca(1:M);
fB_sca = fC_sca(M+1:end);

if ~scalar
    fA_gen = fC_gen(1:M, :);
    fB_gen = fC_gen(M+1:end, :);
end

VarSi_sca = ones(p,1);
VarSTi_sca = ones(p,1);
for i = 1:p
    VarSi_sca(i) = (1/M)*sum(fB_sca.*(fAi_sca(M*(i-1)+1:M*i)-fA_sca));
    
    VarSTi_sca(i) = (1/(2*M))*sum((fA_sca - fAi_sca(M*(i-1)+1:M*i)).^2);
end
VarY_sca = var(fC_sca);

if ~scalar
    VarSi_gen = ones(p, length(time));
    VarSTi_gen = ones(p, length(time));
    VarY_gen   = ones(1, length(time));
    for i = 1:p
        for j = 1:length(time)
            VarSi_gen(i,j) = (1/M)*sum(fB_gen(:,j).*(fAi_gen(M*(i-1)+1:M*i,j)-fA_gen(:,j)));
            
            VarSTi_gen(i,j) = (1/(2*M))*sum((fA_gen(:,j) - fAi_gen(M*(i-1)+1:M*i,j)).^2);
            
            if i == 1
                VarY_gen(j) = var(fC_gen(:,j));
            end
        end
    end
end

Si_sca = VarSi_sca/VarY_sca;
STi_sca = VarSTi_sca/VarY_sca;

%% Outputs

if scalar == 1
    outputs.varSi  = VarSi_sca;
    outputs.varSTi = VarSTi_sca;
    outputs.varY   = VarY_sca;
    outputs.Si     = Si_sca;
    outputs.STi    = STi_sca;
    
else
    sca.varSi   = VarSi_sca; 
    sca.varSTi  = VarSTi_sca;
    sca.varY    = VarY_sca;
    sca.Si      = Si_sca; 
    sca.STi     = STi_sca;
    
    gen.varSi   = VarSi_gen;
    gen.varSTi  = VarSTi_gen;
    gen.varY    = VarY_gen;

    outputs.sca = sca;
    outputs.gen = gen; 
    
end 

if parallel
    delete(gcp('nocreate'));
end
    
end
