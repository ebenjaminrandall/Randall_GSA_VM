%{
DriverBasic_plotopt.m
This script plots the optimized solutions computed DriverBasic_LM.m of the
m1 reduced model.

It requires 'optHR.mat'.
%}

%Clear workspace
clear all
close all

%% Inputs 

load optHR.mat 

printon = 0; %Print for plots

%% Make prediction plots 

%Heart Rate 
hfig1 = figure(1);
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
h2 = plot(time,HR_LM,'r','linewidth',1);
hold on 
set(gca,'FontSize',25)
xlim(Tlims)
ylim(Hlims)
ylabel('H (bpm)')
xlabel('Time (s)')
legend([h1 h2],'Data','Model')
set(gca,'XTick',xtick); 

%Efferent Activity
hfig2 = figure(2);
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
h1 = plot(time,Tpb_LM,'m','linewidth',1);
hold on 
h2 = plot(time,Ts_LM,'g','linewidth',1);
set(gca,'FontSize',25)
xlim(Tlims)
ylabel('Efferent Firing (%)')
xlabel('Time (s)')
legend([h1 h2],'T_{p,b}','T_s')
%ylim([-.1 1.1])
set(gca,'XTick',xtick);
 
if printon == 1
    print(hfig1,'-depsc2','opthr.eps')
    print(hfig2,'-depsc2','eff.eps')

    print(hfig1,'-dpng','opthr.png')
    print(hfig2,'-dpng','eff.png')
end
