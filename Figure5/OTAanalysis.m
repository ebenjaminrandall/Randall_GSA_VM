%{
OTAanalysis.m
This script performs one at a time analysis of noninfluential parameters as
determined by the LMSI GSA. Figures generated are used in Figure 5.

It requires the 'optHR' data. 
 
The script creates 8 figures with overlaying solutions that differ by 
varying one parameter at 'n' different values in its tolerable value range.
%}

%Clear workspace
clear all
close all 

%Load workspace from optimized full model evaluation
load optHR.mat 

%Update echo variable
echoon = 0; 
data.gpars.echoon = echoon; 

%Update parameter bounds
[~,lb,ub] = load_global(data); 

%Set plot limis
Hlims = [40 160]; 
ytick = 40:40:160; 
Tlims = [0 60]; 
xtick = [0 30 60]; 

%Set number of model evaluations per parameter
n = 200; 

%% q_w 

%Prepare figure
figure(1)
clf
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM;

%Generate q_w parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
q_w = ones(n,1)*lb(12) + s(1:n,1)*(ub(12) - lb(12)); 

%Loop for model solves and figure overlays
for i = 1:length(q_w) 
    
    %Update q_w
    p(12) = q_w(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(1)
    hold on 
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
end 

%Clear variables for next figure
clear p s q_w
    
%% s_s 

%Prepare figure
figure(2)
clf
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM; 

%Generate s_s parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
s_s = ones(n,1)*lb(19) + s(1:n,1)*(ub(19) - lb(19)); 

%Loop for model solves and figure overlays
for i = 1:length(s_s) 
    
    %Update s_s
    p(19) = s_s(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(2)
    hold on  
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
    
end 

%Clear variables for next figure
clear p s s_s

%% B

%Prepare figure
figure(3)
clf
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM; 

%Generate B parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
B = ones(n,1)*lb(2) + s(1:n,1)*(ub(2) - lb(2)); 

%Loop for model solves and figure overlays
for i = 1:length(B) 
    
    %Update B
    p(2) = B(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(3)
    hold on 
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
    
end 

%Clear variables for next figure
clear p s B

%% s_pb

%Prepare figure
figure(4)
clf
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM; 

%Generate s_pb parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
s_pb = ones(n,1)*lb(17) + s(1:n,1)*(ub(17) - lb(17)); 

%Loop for model solves and figure overlays
for i = 1:length(s_pb) 
    
    %Update s_pb
    p(17) = s_pb(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(4)
    hold on
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
    
end 

%Clear variables for next figure
clear p s s_pb

%% tau_s 

%Prepare figure
figure(5)
clf
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM; 

%Generate tau_s parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
tau_s = ones(n,1)*lb(10) + s(1:n,1)*(ub(10) - lb(10)); 

%Loop for model solves and figure overlays
for i = 1:length(tau_s) 
    
    %Update tau_s
    p(10) = tau_s(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(5)
    hold on  
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
    
end 

%Clear variables for next figure
clear p s tau_s

%% tau_H

%Prepare figure
figure(6)
clf
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM; 

%Generate tau_H parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
tau_H = ones(n,1)*lb(11) + s(1:n,1)*(ub(11) - lb(11)); 

%Loop for model solves and figure overlays
for i = 1:length(tau_H) 
    
    %Update tau_H
    p(11) = tau_H(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(6)
    hold on  
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
    
end 

%Clear variables for next figure
clear p s tau_H

%% tau_pb

%Prepare figure
figure(7)
clf 
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM; 

%Generate tau_pb parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
tau_pb = ones(n,1)*lb(8) + s(1:n,1)*(ub(8) - lb(8)); 

%Loop for model solves and figure overlays
for i = 1:length(tau_pb) 
    
    %Update tau_pb
    p(8) = tau_pb(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(7)
    hold on
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
    
end 

%Clear variables for next figure
clear p s tau_pb

%% tau_b

%Prepare figure
figure(8)
clf
set(gcf,'renderer','Painters')

%Get parameters
p = pars_LM; 

%Generate tau_b parameter values
s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');
tau_b = ones(n,1)*lb(7) + s(1:n,1)*(ub(7) - lb(7)); 

%Loop for model solves and figure overlays
for i = 1:length(tau_b) 
    
    %Update tau_b
    p(7) = tau_b(i); 
    
    %Solve model
    HR = model_sol(p,data); 
    
    %Plot solution
    figure(8)
    hold on 
    plot(time,HR,'Color',[0.9 0.9 0.9],'linewidth',5)
    
end 

%Clear variables for next figure
clear p s tau_b

%% Make plots 

%Plot HR data on each of the previous figures
hfig1 = figure(1);  
hold on 
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

hfig2 = figure(2);  
hold on
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

hfig3 = figure(3);  
hold on
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

hfig4 = figure(4);  
hold on
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

hfig5 = figure(5);  
hold on
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

hfig6 = figure(6);  
hold on
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

hfig7 = figure(7);  
hold on
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

hfig8 = figure(8);  
hold on
plot(Tdata,Hdata,'b','linewidth',1)
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
set(gca,'XTick',xtick)
set(gca,'YTick',ytick)

%Print the figures
print(hfig1,'-depsc2','-tiff','-r300','q_w.eps')
print(hfig2,'-depsc2','-tiff','-r300','s_s.eps')
print(hfig3,'-depsc2','-tiff','-r300','B.eps')
print(hfig4,'-depsc2','-tiff','-r300','s_pb.eps')
print(hfig5,'-depsc2','-tiff','-r300','tau_s.eps')
print(hfig6,'-depsc2','-tiff','-r300','tau_H.eps')
print(hfig7,'-depsc2','-tiff','-r300','tau_pb.eps')
print(hfig8,'-depsc2','-tiff','-r300','tau_b.eps')

