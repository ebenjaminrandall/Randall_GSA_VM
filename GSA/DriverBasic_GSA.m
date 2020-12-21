%DriverBasic 

clear all
close all

tic 

%% Inputs

load ../FullModel/ForwardEvaluation/nomHR.mat 

echoon  = 0; 
printon = 0;

%% Region 1 - before VM

[pars,low,hi] = load_global(data); 

INDMAP = [1 2 3 4 5 6 7 8 9 ... 
    10 11 12 13 14 15 16 17 18 19 ...
    20 21 22 23];
ALLPARS = pars;

gpars.INDMAP = INDMAP; 
gpars.ALLPARS = ALLPARS;
gpars.echoon = echoon; 

data.gpars = gpars; 

Nsamples = 1e3 * (length(INDMAP) + 2); 
bounds = [low(INDMAP) hi(INDMAP)]; 
data.time = Tnew; 

outputs = tvSob(Nsamples,bounds,data); 

params = {'$A$', '$B$', ...
    '$K_b$','$K_{pb}$','$K_{pr}$','$K_s$', ...
    '$\tau_b$','$\tau_{pb}$','$\tau_{pr}$','$\tau_s$','$\tau_H$',...
    '$q_w$','$q_{pb}$','$q_{pr}$','$q_{s}$', ...
    '$s_w$','$s_{pb}$','$s_{pr}$','$s_{s}$', ...
    '$H_I$','$H_{pb}$','$H_{pr}$','$H_{s}$', ...
    '$D_s$'}; 

Si = outputs.sca.Si; 
STi = outputs.sca.STi; 

[R_Si,I_Si] = sort(Si,'descend'); 
[R_STi,I_STi] = sort(STi,'descend');

elapsed_time = toc/60;

save GSA.mat 




