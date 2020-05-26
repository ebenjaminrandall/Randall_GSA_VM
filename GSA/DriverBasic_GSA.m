%{
DriverBasic_GSA.m
This script performs global sensitivity analysis (GSA) on the full model
computed by ../ForwardEvaluation/DriverBasic.

It requires 'nomHR.mat'. 
 
The script performs GSA via scalar and time-varying Sobol' indices 
(via tvSob.m).

The scalar indices and time-varying variances are saved in 'GSA.mat'.
%}

%Clear workspace
clear all
close all

%Begin timing
tic 

%% Inputs

load nomHR.mat 

echoon  = 0; 
printon = 0;

%% Region 1 - before VM

%Get parameters and bounds
[pars,low,hi] = load_global(data); 

%Set parameters to be sampled
INDMAP = [1 2 3 4 5 6 7 8 9 ... 
    10 11 12 13 14 15 16 17 18 19 ...
    20 21 22 23]; %remove 24 (delay)
ALLPARS = pars;

%Update global parameters
gpars.INDMAP = INDMAP; 
gpars.ALLPARS = ALLPARS;
gpars.echoon = echoon; 

data.gpars = gpars; 

%Set inputs for tvSob.m
Nsamples = 1e3; 
bounds = [low(INDMAP) hi(INDMAP)]; 
data.time = Tnew; 

%Perform GSA
outputs = tvSob(Nsamples,bounds,data); 

params = {'$A$', '$B$', ...
    '$K_b$','$K_{pb}$','$K_{pr}$','$K_s$', ...
    '$\tau_b$','$\tau_{pb}$','$\tau_{pr}$','$\tau_s$','$\tau_H$',...
    '$q_w$','$q_{pb}$','$q_{pr}$','$q_{s}$', ...
    '$s_w$','$s_{pb}$','$s_{pr}$','$s_{s}$', ...
    '$H_I$','$H_{pb}$','$H_{pr}$','$H_{s}$', ...
    '$D_s$'}; 

%Extract and sort scalar indices
Si = outputs.sca.Si; 
STi = outputs.sca.STi; 

[R_Si,I_Si] = sort(Si,'descend'); 
[R_STi,I_STi] = sort(STi,'descend');

%Save results
save GSA.mat 

%End timing
elapsed_time = toc/60
