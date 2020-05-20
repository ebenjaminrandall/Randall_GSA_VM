function Init = initialconditions(pars,data)

%% PARAMETERS 

A  = pars(1);

Kpb = pars(2);
Kpr = pars(3);
Ks  = pars(4); 

qw  = pars(9); 
qpb = pars(10);
qpr = pars(11); 
qs  = pars(12);

sw  = pars(13); 
spb = pars(14);
spr = pars(15); 
ss  = pars(16);

%% INITIAL CONDITIONS

%Pc_0  = data.Pdata(1); 
%ewc_0 = 1 - sqrt((1 + exp(-qw*(Pc_0 - sw)))/(A + exp(-qw*(Pc_0 - sw)))); 

Pa_0  = data.Pdata(1) - data.Pthdata(1); 
ewa_0 = 1 - sqrt((1 + exp(-qw*(Pa_0 - sw)))/(A + exp(-qw*(Pa_0 - sw)))); 

%n_0   = B*ewc_0 + (1 - B)*ewa_0;

Gpb_0 = 1/(1 + exp(-qpb*(ewa_0 - spb)));
Gpr_0 = 1/(1 + exp(qpr*(data.Pthdata(1) - spr)));
Gs_0  = 1/(1 + exp(qs*(ewa_0 - ss))); 

Tpb_0 = Kpb*Gpb_0; 
Tpr_0 = Kpr*Gpr_0;
Ts_0  = Ks*Gs_0; 

%% OUTPUT

Init = [Tpb_0; Tpr_0; Ts_0; data.Hdata(1)];
