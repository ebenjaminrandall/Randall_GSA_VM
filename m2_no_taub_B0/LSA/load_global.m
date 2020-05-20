function [pars, lb, ub] = load_global(data)

age    = data.age;  

%Initial mean values
Pbar   = data.Pbar;
HminR  = data.HminR; 
HmaxR  = data.HmaxR; 
Hbar   = data.Hbar; 

%% PARAMETERS  

A    = 5;          
%B    = 0.5;           

Kb   = 0.1;          
Kpb  = 5;
Kpr  = 1; 
Ks   = 5; 

%taub  = 0.9;           
taupb = 1.8;          
taupr = 6;
taus  = 10;          
tauH  = 0.5;

qw   = .04;        
qpb  = 10*(1 - Kb);          
qpr  = 1; 
qs   = 10*(1 - Kb);          

Ds   = 3;            

%% Patient specific parameters

sw  = Pbar;           
spr = data.Pthbar;  

%Intrinsic HR
HI = 118 - .57*age;  
if HI < Hbar 
    HI = Hbar;
end 
%Maximal HR
HM = 208 - .7*age;    
Hs = (1/Ks)*(HM/HI - 1); 

%% Calculate sigmoid shifts

%Pc_ss  = data.Pbar; 
%ewc_ss = 1 - sqrt((1 + exp(-qw*(Pc_ss - sw)))/(A + exp(-qw*(Pc_ss - sw)))); 

Pa_ss  = data.Pbar - data.Pthbar; 
ewa_ss = 1 - sqrt((1 + exp(-qw*(Pa_ss - sw)))/(A + exp(-qw*(Pa_ss - sw)))); 

%n_ss   = B*ewc_ss + (1 - B)*ewa_ss;

Tpb_ss = .8;
Ts_ss  = .2; 

%Steady-state sigmoid shifts 
spb = ewa_ss + log(Kpb/Tpb_ss - 1)/qpb;  
ss  = ewa_ss -  log(Ks/Ts_ss - 1)/qs;   

%% At end of expiration and inspiration

Gpr_ss = 1/(1 + exp(qpr*(data.Pthbar - spr)));

Tpr_ss = Kpr*Gpr_ss; 
Hpr = (HmaxR - HminR)/HI/Tpr_ss ;

Hpb = (1 - Hbar/HI + Hpr*Tpr_ss + Hs*Ts_ss)/Tpb_ss;

%% Outputs

pars = [A;              
    Kpb; Kpr; Ks;               %Gains
    taupb; taupr; taus; tauH; %Time Constants
    qw; qpb; qpr; qs;               %Sigmoid Steepnesses
    sw; spb; spr; ss;               %Sigmoid Shifts
    HI; Hpb; Hpr; Hs;               %Heart Rate Parameters 
    Ds];                            %Delay

%% Parameter bounds

%Vary nominal parameters by +/- 50%
lb  = pars*.5; 
ub  = pars*1.5;

% %B - Convex combination
% lb(2)  = .01;                       
% ub(2)  = 1;                        

% %K_b - Allowed to vary to contain literature values
% lb(3)  = .1;                        
% ub(3)  = 10;                        

%K_pb - Allowed to vary to contain literature values
lb(2)  = .1;                      
ub(2)  = 10;                       

%K_pr - Allowed to vary to contain literature values
lb(3)  = .1;                        
ub(3)  = 10;                      

%K_s - Allowed to vary to contain literature values
lb(4)  = .1;                       
ub(4)  = 10;                

% %tau_b - Allowed to vary to contain literature values
% lb(7)  = .01;                      
% ub(7)  = 1.5;             

%tau_pb - M p/m 2 SD 
lb(5)  = max(6.5 - 2*5.7,0.01);    
ub(5)  = 6.5 + 2*5.7;               

%tau_pr - M p/m 2 SD 
lb(6)  = max(9.6 - 2*10.8,0.01);    
ub(6)  = 9.6 + 2*10.8;                                                  

%s_w - M p/m 2 SD
lb(13) = max(123 - 2*20,0.01);      
ub(13) = 123 + 2*20;               

%s_pb - M p/m 2 SD
lb(14) = max(0.54 - 2*5e-3,0.01);   
ub(14) = 0.54 + 2*5e-3;        

%s_pr - M p/m 2 SD
lb(15) = max(4.88 - 2*0.21,0.01); 
ub(15) = 4.88 + 2*0.21;             

%s_s - M p/m 2 SD
lb(16) = max(0.05 - 2*5e-3,0.01);  
ub(16) = 0.05 + 2*5e-3;          

%H_I - M p/m 2 SD 
lb(17) = max(100 - 2*7,0.01);     
ub(17) = 100 + 2*7;           

%H_pb - M p/m 2 SD 
lb(18) = max(0.5 - 2*0.2,0.01);     
ub(18) = 0.5 + 2*0.2;             

%H_pr -  M p/m 2 SD - calc
lb(19) = max(0.3 - 2*0.4,0.01);   
ub(19) = 0.3 + 2*0.4;              

%H_s - M p/m 2 SD - calc
lb(20) = max(0.3 - 2*0.4,0.01);     
ub(20) = 0.3 + 2*0.4;                         

%% Outputs

pars = log(pars);
lb   = log(lb);
ub   = log(ub); 

end 
