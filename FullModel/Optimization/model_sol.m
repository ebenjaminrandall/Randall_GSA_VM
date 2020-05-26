function [HR,rout,J,Outputs] = model_sol(pars,data)
%{
model_sol.m
This function calls the Fortran-created executable to solve the full model.

Inputs:
    pars:   vector of log-scaled nominal parameter values
    data:   structure that contains all preprocessed VM data

Outputs:
    HR:         heart rate solution to differential equations
    rout:       residual vector (the relative difference between model and
                data)
    J:          scalar cost function
    Outputs:    matrix containing time and other solutions to differential
                equations
%}

%Recover parameters
pars = exp(pars); 

%% Unpack structure 

tspan   = data.Tdata;
Pdata   = data.Pdata; 
Pthdata = data.Pthdata; 
Rdata   = data.Rdata; 
Hdata   = data.Hdata; 
dt      = data.dt; 
echoon  = data.gpars.echoon; 

%% Get initial conditions 

Init = initialconditions(pars,data); 

%% Write data files up to event

%Write initial conditions vector
fid = fopen('FortranData/Init.txt','w');
fprintf(fid,'%6i \n',length(Init)); 
for i = 1:length(Init)
   fprintf(fid,'%26.18E \n',Init(i));
end
fclose(fid);

%Write parameter vector - MUST HAVE LENGTH OF VECTOR FIRST! 
fid = fopen('FortranData/Pars.txt','w');
fprintf(fid,'%6i \n',length(pars));
for i = 1:length(pars)
   fprintf(fid,'%26.18E \n',pars(i));
end
fclose(fid);

%Write time vector - MUST HAVE LENGTH OF VECTOR FIRST!
fid = fopen('FortranData/Time.txt','w');
fprintf(fid,'%6i \n',length(tspan));
for i = 1:length(tspan)
   fprintf(fid,'%26.18E \n',tspan(i));
end
fclose(fid);

%Write time vector - MUST HAVE LENGTH OF VECTOR FIRST!
fid = fopen('FortranData/dt.txt','w');
fprintf(fid,'%26.18E \n',dt);
fclose(fid);

%Write mean blood pressure (from movmean) vector - MUST HAVE LENGTH OF VECTOR FIRST!
fid = fopen('FortranData/Pmean.txt','w');
fprintf(fid,'%6i \n',length(Pdata));
for i = 1:length(Pdata)
   fprintf(fid,'%26.18E \n',Pdata(i));
end
fclose(fid);

%Write thoracic pressure vector - MUST HAVE LENGTH OF VECTOR FIRST!
fid = fopen('FortranData/Pthdata.txt','w');
fprintf(fid,'%6i \n',length(Pthdata));
for i = 1:length(Pthdata)
   fprintf(fid,'%26.18E \n',Pthdata(i));
end
fclose(fid);

%Write thoracic pressure vector - MUST HAVE LENGTH OF VECTOR FIRST!
fid = fopen('FortranData/Rdata.txt','w');
fprintf(fid,'%6i \n',length(Rdata));
for i = 1:length(Rdata)
   fprintf(fid,'%26.18E \n',Rdata(i));
end
fclose(fid);
 
%% Solve model 

if echoon == 1
    [status,blah] = unix('./driver','-echo');
else
    [status,blah] = unix('./driver'); 
end 

s    = load('cont.out');
time = s(:,1);
ebc = s(:,2);
eba = s(:,3); 
Tpb  = s(:,4); 
Tpr  = s(:,5); 
Ts  = s(:,6); 
HR  = s(:,7); 

if round(time(end-1),2) == round(tspan(end),2)  
    time = time(1:end-1); 
    ebc = ebc(1:end-1);
    eba = eba(1:end-1); 
    Tpb = Tpb(1:end-1);
    Tpr = Tpr(1:end-1); 
    Ts = Ts(1:end-1);
    HR = HR(1:end-1); 
end 

%% Interpolate solution and calculate outputs

HM = max(Hdata); 

rout = [(HR - Hdata)./Hdata/sqrt(length(Hdata)); 
    (max(HR) - HM)/HM]; 

J = rout'*rout;

Outputs = [time,ebc,eba,Tpb,Ts,Tpr]; 

end
