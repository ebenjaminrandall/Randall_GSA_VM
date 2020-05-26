%{
DriverBasic.m
This script performs a forward evaulation of the full model.

It requires the 'FP2_VM6_long.mat' data. 
 
The script generates a structure called 'data' to be used in other 
functions, gets nominal parameter values, evaluates the forward model by 
calling the Fortran-created executable, calculates clinical ratios, and 
creates plots.

The model solution and variables are saved in 'nomHR.mat'.
%}

%Clear workspace
clear all
close all

%Begin timing
tic 

%% Inputs

echoon  = 1; %Echo for executable status in model solve
printon = 0; %Print for data figures

%% Load data and preprocess data 

load FP2_VM6_long.mat 
 
x = 100; 

dt = mean(diff(Tdata)); 
ll = 45; 
y = round(ll/dt)+1; 
z = length(Tdata) - round(ll/dt);

Tdata   = Tdata(y:z); 
Tdata   = Tdata - Tdata(1); 
ECG     = ECG(y:z);
Hdata   = Hdata(y:z); 
Pdata   = Pdata(y:z); 
SPdata  = SPdata(y:z);
Pthdata = Pthdata(y:z); 
Rdata   = Rdata(y:z); 

Tnew   = Tdata(1:x:end);
Hnew   = Hdata(1:x:end);
Pthnew = Pthdata(1:x:end);
SPnew  = SPdata(1:x:end);
Rnew   = Rdata(1:x:end); 

dt = mean(diff(Tnew)); 

%% Find event time

Pdiff    = diff(Pthnew); 
[~,ts]   = max(Pdiff);      %VM start index
[~,te]   = min(Pdiff);      %VM end index
h        = Hnew(te:round(te + 5/dt));
hdiff    = diff(h);
[~,ind1] = min(hdiff);
tr       = te + ind1;       %VM reset index

%% Find steady-state baseline values up to VM start

HminR = min(Hnew(1:ts-1)); 
HmaxR = max(Hnew(1:ts-1)); 
Hbar = trapz(Hnew(1:ts-1))/(ts-1); 
Rbar = trapz(Rnew(1:ts-1))/(ts-1); 
Pbar = trapz(SPnew(1:ts-1))/(ts-1); 

%% Find time for end of phase IV 

%Find when SBP returns to baseline at end of phase IV 
ind2 = find(SPnew(tr:end) <= Pbar,1,'first');
if isempty(ind2) == 1
    t4 = length(SPnew);
else 
    t4 = tr + ind2 - 1;
end 

%Check in case t4 > length of signal 
if t4 > length(SPnew)
    t4 = length(SPnew); 
end 

%Check in case t4 = tr
if t4 == tr 
    ind2 = find(SPnew(tr+round(5/dt):end) >= Pbar,1,'last');
    t4 = tr + round(5/dt) + ind2 - 1; 
end  

%% Make thoracic pressure signal 

Rnew1 = -Rnew; 

[a,~] = findpeaks(Rnew1(1:ts-1)); 
[b,bloc] = findpeaks(-Rnew1(1:ts-1)); 
b = -b; 
R_exh = mean(a); 
R_inh = mean(b);
R_amp = R_exh - R_inh; 


Amp_normal = 6 - 3.5; 

Amp = Amp_normal/R_amp; 

rr = Amp*Rnew1; 

[a,aloc] = findpeaks(-rr(1:ts-1));
R_exh = -mean(a); 
m = 3.5 - R_exh;

PR = rr+m ; 

Pthor = [PR(1:ts-1); 
    Pthnew(ts:te);
    PR(te+1:end)];
z = find(Pthor < 0);
Pthor(z) = 0;  

Pthor = movmean(Pthor,10);

Pthbar = trapz(Pthor(1:ts-1))/(ts-1); 

%% Create data structure 

data.Tdata   = Tnew;
data.Pdata   = SPnew; 
data.Hdata   = Hnew;
data.Pthdata = Pthor;
data.Rdata   = Rnew; 
data.Pbar    = Pbar;
data.Pthbar  = Pthbar;
data.HminR   = HminR;
data.HmaxR   = HmaxR;
data.Hbar    = Hbar; 
data.Rbar    = Rbar; 
data.ts      = ts; 
data.te      = te; 
data.tr      = tr;
data.t4      = t4; 
data.age     = age; 
data.dt      = dt; 

%Global parameters substructure
gpars.echoon = echoon; 

data.gpars   = gpars; 

%% Get nominal parameter values

pars = load_global(data); 

%% Solve model with nominal parameters 

[HR,~,~,Outputs] = model_sol(pars,data);

time = Outputs(:,1);
ebc  = Outputs(:,2);
eba  = Outputs(:,3); 
Tpb  = Outputs(:,4);
Ts   = Outputs(:,5);
Tpr  = Outputs(:,6); 

%% Extract indices from data and calculate clinical ratios

[values,indices,ratios,alphaplot] = clinicalratios(data); 

SPmaxI  = values(1); 
SPendI  = values(2); 
SPminII = values(3); 
SPmaxII = values(4); 
SPmaxIV = values(5); 
HmaxIII = values(6); 
HminIV  = values(7); 

k_SPmaxI  = indices(1);
k_SPendI  = indices(2); 
k_SPminII = indices(3); 
k_SPmaxII = indices(4); 
k_SPmaxIV = indices(5); 
k_HmaxIII = indices(6); 
k_HminIV  = indices(7); 

ratios = round(ratios,1);  

alpha = ratios(1); 
beta  = ratios(2); 
gamma = ratios(3);  

x_alpha = alphaplot.x_alpha;
yfit_alpha = alphaplot.yfit_alpha;
p_alpha = alphaplot.p_alpha; 

%% Set plot limits

m_eff = min(min(Tpb,Ts)); 
if m_eff < 0 
    efflims = [1.1*m_eff 1.1*max(max(Tpb,Ts))]; 
else
    efflims = [0 1.1*max(max(Tpb,Ts))]; 
end 

%X- and Y- axis limits for plots
Tlims   = [0 Tnew(end)]; 
xtick   = 0:30:90;
Plims   = [min(Pdata)-10 max(Pdata)+10]; 
Hlims   = [min(Hdata)-5 max(Hdata)+5];
Pthlims = [-1 max(Pthdata)+1]; 
SPlims  = [min(SPdata)-5 max(SPdata)+5]; 
afflims = [0.9*min(eba) 1.1*max(eba)]; 
Tprlims = [0 1]; 
Elims   = [-1.1 1.1]; 

%Times for VM phases
tsVM = Tnew(ts);
t1 = Tnew(k_SPendI);
t2 = Tnew(k_SPminII);
teVM = Tnew(te); 
trVM = Tnew(tr); 
t4VM = Tnew(t4); 

%Identity
I = ones(2,1); 

%X values for shaded regions for each VM phase
x1   = [tsVM t1 t1 tsVM];
x2   = [t1 teVM teVM t1]; 
x3   = [teVM trVM trVM teVM];
x4   = [trVM t4VM t4VM trVM]; 

%Y values for shaded regions for each VM phase
yH   = [Hlims(1) Hlims(1) Hlims(2) Hlims(2)]; 
yP   = [Plims(1) Plims(1) Plims(2) Plims(2)];
ySP  = [SPlims(1) SPlims(1) SPlims(2) SPlims(2)]; 
yPth = [Pthlims(1) Pthlims(1) Pthlims(2) Pthlims(2)]; 
yaff = [afflims(1) afflims(1) afflims(2) afflims(2)];
yeff = [efflims(1) efflims(1) efflims(2) efflims(2)]; 
yTpr = [Tprlims(1) Tprlims(1) Tprlims(2) Tprlims(2)]; 
yE   = [Elims(1) Elims(1) Elims(2) Elims(2)]; 

%Colors 
gray  = [0.875 0.875 0.875]; 
lgray = [0.95 0.95 0.95];

save nomHR.mat 

%% Make data plots

%ECG
hfig1 = figure(1);
clf 
hold on 
patch(x1,yE,gray)
hold on 
patch(x2,yE,lgray)
hold on 
patch(x3,yE,gray)
hold on 
patch(x4,yE,lgray)
hold on 
plot(t2*I,Elims,'k:','linewidth',0.5)
hold on 
h1 = plot(Tdata,ECG,'b','linewidth',0.25);
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Elims)
ylabel('ECG (mv)')
xlabel('Time (s)')
set(gca,'XTick',xtick); 

%Pressures
hfig2 = figure(2);
clf
patch(x1,yP,gray)
hold on 
patch(x2,yP,lgray)
hold on 
patch(x3,yP,gray)
hold on 
patch(x4,yP,lgray)
hold on 
plot(t2*I,Plims,'k:','linewidth',0.5)
hold on 
plot(Tlims,Pbar*I,'k:','linewidth',0.5);
hold on 
h1 = plot(Tdata,Pdata,'b','linewidth',0.25); 
hold on 
h2 = plot(Tnew,SPnew,'b','linewidth',1);
hold on 
xlabel('Time (s)')
ylabel('P (mmHg)')
ylim(Plims)
xlim(Tlims)
set(gca,'FontSize',25)
legend([h1,h2],'PP','SBP')
set(gca,'XTick',xtick);

%Thoracic Pressure 
hfig3 = figure(3);
clf
patch(x1,yPth,gray)
hold on 
patch(x2,yPth,lgray)
hold on 
patch(x3,yPth,gray)
hold on 
patch(x4,yPth,lgray)
hold on 
plot(t2*I,Pthlims,'k:','linewidth',0.5)
hold on 
h1 = plot(Tnew,Pthor,'b','linewidth',1); 
xlabel('Time (s)')
ylabel('P_{th} (mmHg)')
xlim(Tlims)
ylim(Pthlims)
set(gca,'FontSize',16)
set(gca,'XTick',xtick);

%Heart Rate 
hfig4 = figure(4);
clf 
hold on 
patch(x1,yH,gray)
hold on 
patch(x2,yH,lgray)
hold on 
patch(x3,yH,gray)
hold on 
patch(x4,yH,lgray)
hold on 
plot(t2*I,Hlims,'k:','linewidth',0.5)
hold on 
h1 = plot(Tdata,Hdata,'b','linewidth',1);
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)

if printon == 1
    print(hfig1,'-depsc2','ecg.eps')
    print(hfig2,'-depsc2','bp.eps')
    print(hfig3,'-depsc2','pth.eps')
    print(hfig4,'-depsc2','hr.eps')

    print(hfig1,'-dpng','ecg.png')
    print(hfig2,'-dpng','bp.png')
    print(hfig3,'-dpng','pth.png')
    print(hfig4,'-dpng','hr.png')
end

%% Make prediction plots 

%Heart Rate 
hfig5 = figure(5);
clf 
hold on 
patch(x1,yH,gray)
hold on 
patch(x2,yH,lgray)
hold on 
patch(x3,yH,gray)
hold on 
patch(x4,yH,lgray)
hold on 
plot(t2*I,Hlims,'k:','linewidth',0.5)
hold on 
h1 = plot(Tdata,Hdata,'b','linewidth',1);
hold on 
h2 = plot(time,HR,'r','linewidth',1);
hold on 
set(gca,'FontSize',25)
xlim(Tlims)
ylabel('H (bpm)')
xlabel('Time (s)')
legend([h1 h2],'Data','Model')
set(gca,'XTick',xtick); 

%Baroreceptor Strain
hfig6 = figure(6); 
clf 
patch(x1,yaff,gray)
hold on 
patch(x2,yaff,lgray)
hold on 
patch(x3,yaff,gray)
hold on 
patch(x4,yaff,lgray)
hold on 
plot(t2*I,afflims,'k:','linewidth',0.5)
hold on 
h1 = plot(time,eba,'color',[0 0.75 0.75],'linewidth',1); 
hold on 
h2 = plot(time,ebc,'r','linewidth',1);
set(gca,'FontSize',25)
xlim(Tlims)
ylim(afflims)
ylabel('Baroreceptor Strain')
xlabel('Time (s)')
legend([h1 h2],'Aortic','Carotid')
set(gca,'XTick',xtick);

%Efferent Activity
hfig7 = figure(7);
clf
patch(x1,yeff,gray)
hold on 
patch(x2,yeff,lgray)
hold on 
patch(x3,yeff,gray)
hold on 
patch(x4,yeff,lgray)
hold on 
plot(t2*I,efflims,'k:','linewidth',0.5)
hold on
h1 = plot(time,Tpb,'m','linewidth',1);
hold on 
h2 = plot(time,Ts,'g','linewidth',1);
set(gca,'FontSize',25)
xlim(Tlims)
ylabel('Efferent Firing (%)')
xlabel('Time (s)')
legend([h1 h2],'T_{p,b}','T_s')
%ylim([-.1 1.1])
set(gca,'XTick',xtick);

%Respiration Signal
hfig8 = figure(8); 
clf
patch(x1,yTpr,gray)
hold on 
patch(x2,yTpr,lgray)
hold on 
patch(x3,yTpr,gray)
hold on 
patch(x4,yTpr,lgray)
hold on 
plot(t2*I,Tprlims,'k:','linewidth',0.5)
hold on 
plot(time,Tpr,'c','linewidth',1)
xlim(Tlims)
set(gca,'FontSize',25)
xlabel('Time (s)')
set(gca,'XTick',xtick);
ylabel('Respiratory Efferent (%)')

%Plot regression on top of SBP data  
hfig9 = figure(9); 
clf
patch(x1,ySP,gray)
hold on 
patch(x2,ySP,lgray)
hold on 
patch(x3,ySP,gray)
hold on 
patch(x4,ySP,lgray)
hold on 
plot(t2*ones(2,1),SPlims,'k:','linewidth',0.5)
hold on 
h1 = plot(Tnew,SPnew,'Color','b','linewidth',1);
hold on 
if isempty(yfit_alpha) ~= 1
    h2 = plot(x_alpha,yfit_alpha,'r','linewidth',1); 
    thestring = sprintf('y = %.1f x + %.1f',p_alpha(1),p_alpha(2)); 
    legend(h2,thestring,'location','northwest') 
end
xlim(Tlims)
ylim(SPlims)
xlabel('Time (s)')
ylabel('SBP (mmHg)')
set(gca,'FontSize',25)
set(gca,'Xtick',xtick)

% End timing
elapsed_time = toc
