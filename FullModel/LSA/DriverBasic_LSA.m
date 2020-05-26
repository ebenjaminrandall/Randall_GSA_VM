%{
DriverBasic_LSA.m
This script performs local sensitivity analysis (LSA) on the full model
computed by ../ForwardEvaluation/DriverBasic.

It requires 'nomHR.mat' in the ForwardEvaluation folder, i.e. it requires
'../ForwardEvaluation/nomHR.mat'. 
 
The script performs LSA via finite forward differences (via senseq.m),
generates the sensitivity matrix (via senseq.m), and ranks the Euclidean
norm of the sensitivities.

The sensitivity matrix and rankings are saved in 'sens.mat'.
%}

%Clear workspace
clear all
close all

%Begin timing
tic 
                                
%% Load data  

load ../ForwardEvaluation/nomHR.mat 

echoon  = 0; %Echo for executable status in model solve

%% Get nominal parameter values

%Global parameters
ODE_TOL  = 1e-8;
DIFF_INC = sqrt(ODE_TOL);

gpars.ODE_TOL  = ODE_TOL;
gpars.DIFF_INC = DIFF_INC; 
gpars.echoon = echoon;

data.gpars = gpars; 

%% Sensitivity Analysis

%senseq finds the non-weighted sensitivities
sens = senseq(pars,data);

sens = abs(sens); 

%ranked classical sensitivities
[M,N] = size(sens);
for i = 1:N 
    sens_norm(i)=norm(sens(:,i),2);
end

%sens_norm = sens_norm(1:end-2); 
[Rsens,Isens] = sort(sens_norm,'descend');
display([Isens]); 

params = {'$A$', '$B$', ...
    '$K_b$','$K_{pb}$','$K_{pr}$','$K_s$', ...
    '$\tau_b$','$\tau_{pb}$','$\tau_{pr}$','$\tau_s$','$\tau_H$',...
    '$q_w$','$q_{pb}$','$q_{pr}$','$q_{s}$', ...
    '$s_w$','$s_{pb}$','$s_{pr}$','$s_{s}$', ...
    '$H_I$','$H_{pb}$','$H_{pr}$','$H_{s}$', ...
    '$D_s$'}; 

%Save sensitivity results
save sens.mat

%End timing
elapsed_time = toc
