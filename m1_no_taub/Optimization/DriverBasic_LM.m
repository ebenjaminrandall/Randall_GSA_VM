%{
DriverBasic_LM.m
This script performs Levenberg-Marquardt (LM) optimization on the 
uncorrelated subset of parameters determined by the covariance analysis
of the m1 reduced model.

It requires 'nomHR.mat' in the ForwardEvaluation folder, i.e. it requires
'../ForwardEvaluation/nomHR.mat'. 
 
The script performs LM optimization (via newlsq_v2.m) and simulates the 
model at the optimized parameter values.

The results are saved in 'optHR.mat'.
%}

%Clear workspace
clear all
close all

%Begin timing
tic
                                
%% Inputs

load ../ForwardEvaluation/nomHR.mat

echoon = 0; %Echo for executable status in model solve
senson = 0; 

%% Get nominal parameter values

[pars,low,hi] = load_global(data); 

%Global parameters
INDMAP = [2 6 7 19 20 21]
ALLPARS  = pars;
ODE_TOL  = 1e-10; 
DIFF_INC = sqrt(ODE_TOL);

%Update global parameter substructure
gpars.INDMAP   = INDMAP;
gpars.ALLPARS  = ALLPARS;
gpars.ODE_TOL  = ODE_TOL;
gpars.DIFF_INC = DIFF_INC;
gpars.echoon   = echoon;
gpars.senson   = senson; 

data.gpars = gpars;

%% Optimization - lsqnonlin

%Set up newlsq_v2 inputs
optx   = pars(INDMAP); 
opthi  = hi(INDMAP);
optlow = low(INDMAP);
maxiter = 40; 
mode    = 2; 
nu0     = 2.d-1; 

%Perform LM optimization
[xopt, histout, costdata, jachist, xhist, rout, sc] = ...
     newlsq_v2(optx,'opt_wrap',1.d-4,maxiter,...
     mode,nu0,opthi,optlow,data); 

pars_LM = pars;
pars_LM(INDMAP) = xopt; 

%Simulate model at optimized values 
[HR_LM,rout,J,Outputs] = model_sol(pars_LM,data);

%Display optimized parameters
optpars = exp(pars_LM);
disp('optimized parameters')
disp([INDMAP' optpars(INDMAP)])

%Extract solutions
time = Outputs(:,1); 
Tpb_LM  = Outputs(:,2);
Ts_LM   = Outputs(:,3);
Tpr_LM  = Outputs(:,4); 

%Save optimized results
save optHR.mat 

%End timing
elapsed_time = toc;
elapsed_time = elapsed_time/60
