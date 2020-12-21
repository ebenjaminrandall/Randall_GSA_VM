%{
Plots pointwise-in-time time-varying Sobol' indices. 
%} 

clear all
%close all 

load differentwindowstest.mat

%INDMAP = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16  18  20 21 22 23]; 
printon = 1; 


xx = 1:length(Tnew); %find(Tnew >= 15 & Tnew <= Tnew(end)-15); 
tt = Tnew; 
tt = tt - tt(1); 

xlimits = [time(1) time(end)]; %[0 60]; 
eta1 = 1e-1; 
eta2 = 1e-3; 
fontS = 8; 

%% Most influential 

ylimits = [-.01 .7]; 
hfig10 = figure(10);
clf
set(gcf,'units','normalized','outerposition',[0 0 .45 .3]); 

h = semilogy(tt,STi_pw(I_STi(1:5),:),'linewidth',1); 
hold on 
plot(xlimits,eta1*ones(2,1),'k--',xlimits,eta2*ones(2,1),'k--')
plot(Tnew(ts)*ones(2,1),ylimits,'k-.',Tnew(t4)*ones(2,1),ylimits,'k-.')
plot(xlimits,zeros(2,1),'k')
txt = '$\eta_1$'; 
text(Tnew(end)+.5,eta1,txt,'interpreter','latex','Fontsize',fontS)
txt = '$\eta_2$'; 
text(Tnew(end)+.5,eta2,txt,'interpreter','latex','Fontsize',fontS)

set(gca,'FontSize',fontS)

xlim(xlimits) 
xtick = Tnew(1):30:Tnew(end); 
set(gca,'Xtick',xtick)

ylim([1e-2 1])
ytick = [1e-2 1e-1 1];% 0:.2:ylimits(end); 
set(gca,'Ytick',ytick)

legend(h,params(INDMAP(I_STi(1:5))),'interpreter','latex','location','northwest')

%% Mid influential 

ylimits = [-.001 .075]; 
hfig11 = figure(11); 
clf
set(gcf,'units','normalized','outerposition',[0 0 .45 .3])

h = semilogy(tt,STi_pw(I_STi(6:15),xx),'linewidth',1); 
hold on 
plot(xlimits,eta1*ones(2,1),'k--',xlimits,eta2*ones(2,1),'k--')
plot(Tnew(ts)*ones(2,1),ylimits,'k-.',Tnew(t4)*ones(2,1),ylimits,'k-.')
plot(xlimits,zeros(2,1),'k')
txt = '$\eta_1$'; 
text(Tnew(end)+.5,eta1,txt,'interpreter','latex','Fontsize',fontS)
txt = '$\eta_2$'; 
text(Tnew(end)+.5,eta2,txt,'interpreter','latex','Fontsize',fontS)

set(gca,'FontSize',fontS)

xlim(xlimits)
xtick = Tnew(1):30:Tnew(end); 
set(gca,'Xtick',xtick)

ylim([3e-5 1.5e-1])
ytick = [1e-4 1e-2]; %0:.05:ylimits(end); 
set(gca,'Ytick',ytick)

legend(h,params(INDMAP(I_STi(6:15))),'interpreter','latex','location','northwest')

%% Least influential 

ylimits = [-.0001 .0045]; 
hfig12 = figure(12); 
clf
set(gcf,'units','normalized','outerposition',[0 0 .45 .3]); 

h = semilogy(tt,STi_pw(I_STi(16:length(I_STi)),xx),'linewidth',1); 
hold on 
plot(xlimits,eta2*ones(2,1),'k--')
plot(Tnew(ts)*ones(2,1),ylimits,'k-.',Tnew(t4)*ones(2,1),ylimits,'k-.')
plot(xlimits,zeros(2,1),'k')
txt = '$\eta_2$'; 
text(Tnew(end)+.5,eta2,txt,'interpreter','latex','Fontsize',fontS)

set(gca,'FontSize',fontS)

xlim(xlimits)
xtick = Tnew(1):30:Tnew(end); 
set(gca,'Xtick',xtick)

ylim([1e-7 5e-3])
ytick = [1e-6 1e-4];% 0:.002:ylimits(end); 
set(gca,'Ytick',ytick)

legend(h,params(INDMAP(I_STi(16:length(I_STi)))),'interpreter','latex','location','northwest') 

%% Print figs 

if printon == 1
    print(hfig10,'-depsc2','STiPW_most.eps')
    print(hfig11,'-depsc2','STiPW_mid.eps')
    print(hfig12,'-depsc2','STiPW_least.eps') 
    
    print(hfig10,'-dpng','STiPW_most.png')
    print(hfig11,'-dpng','STiPW_mid.png')
    print(hfig12,'-dpng','STiPW_least.png') 
end 