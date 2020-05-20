%{
Plots generalzied time-varying Sobol' indices. 
%} 

clear all
close all 

load differentwindows.mat

printon = 1; 

xx = 1:length(Tnew(2:end)); %find(Tnew >= 15 & Tnew <= Tnew(end)-15); 
tt = Tnew(2:end); 
tt = tt - tt(1); 

xlimits = [time(1) time(end)]; %[0 60]; 
eta1 = 1e-1; 
eta2 = 1e-3; 
fontS = 10; 

%% Most influential 

ylimits = [-.01 .7]; 
hfig10 = figure(10);
clf
set(gcf,'units','normalized','outerposition',[0 0 .45 .3]); 

h = plot(tt,STi_0(I_STi(1:5),:),'linewidth',1); 
hold on 
plot(xlimits,eta1*ones(2,1),'k--',xlimits,eta2*ones(2,1),'k--')
plot(Tnew(ts)*ones(2,1),ylimits,'k-.',Tnew(t4)*ones(2,1),ylimits,'k-.')
plot(xlimits,zeros(2,1),'k')
txt = '$\eta_1$'; 
text(Tnew(end)+1,eta1,txt,'interpreter','latex','Fontsize',fontS)
txt = '$\eta_2$'; 
text(Tnew(end)+1,eta2,txt,'interpreter','latex','Fontsize',fontS)

set(gca,'FontSize',fontS)

xlim(xlimits) 
xtick = Tnew(1):30:Tnew(end); 
set(gca,'Xtick',xtick)

ylim(ylimits)
ytick = 0:.2:ylimits(end); 
set(gca,'Ytick',ytick)

legend(h,params(INDMAP(I_STi(1:5))),'interpreter','latex','location','northwest')

%% Mid influential 

ylimits = [-.001 .075]; 
hfig11 = figure(11); 
clf
set(gcf,'units','normalized','outerposition',[0 0 .45 .3])

h = plot(tt,STi_0(I_STi(6:14),xx),'linewidth',1); 
hold on 
plot(xlimits,eta1*ones(2,1),'k--',xlimits,eta2*ones(2,1),'k--')
plot(Tnew(ts)*ones(2,1),ylimits,'k-.',Tnew(t4)*ones(2,1),ylimits,'k-.')
plot(xlimits,zeros(2,1),'k')
txt = '$\eta_1$'; 
text(Tnew(end)+1,eta1,txt,'interpreter','latex','Fontsize',fontS)
txt = '$\eta_2$'; 
text(Tnew(end)+1,eta2,txt,'interpreter','latex','Fontsize',fontS)

set(gca,'FontSize',fontS)

xlim(xlimits)
xtick = Tnew(1):30:Tnew(end); 
set(gca,'Xtick',xtick)

ylim(ylimits)
ytick = 0:.05:ylimits(end); 
set(gca,'Ytick',ytick)

legend(h,params(INDMAP(I_STi(6:14))),'interpreter','latex','location','northwest')

%% Least influential 

ylimits = [-.0001 .0055]; 
hfig12 = figure(12); 
clf
set(gcf,'units','normalized','outerposition',[0 0 .45 .3]); 

h = plot(tt,STi_0(I_STi(15:length(I_STi)),xx),'linewidth',1); 
hold on 
plot(xlimits,eta2*ones(2,1),'k--')
plot(Tnew(ts)*ones(2,1),ylimits,'k-.',Tnew(t4)*ones(2,1),ylimits,'k-.')
plot(xlimits,zeros(2,1),'k')
txt = '$\eta_2$'; 
text(55,.0002,txt,'interpreter','latex','Fontsize',fontS)

set(gca,'FontSize',fontS)

xlim(xlimits)
xtick = Tnew(1):30:Tnew(end); 
set(gca,'Xtick',xtick)

ylim(ylimits)
ytick = 0:.005:ylimits(end); 
set(gca,'Ytick',ytick)

legend(h,params(INDMAP(I_STi(15:length(I_STi)))),'interpreter','latex','location','northwest') 

%% Print figs 


if printon == 1
    print(hfig10,'-depsc2','STiGen_most.eps')
    print(hfig11,'-depsc2','STiGen_mid.eps')
    print(hfig12,'-depsc2','STiGen_least.eps') 
    
    print(hfig10,'-dpng','STiGen_most.png')
    print(hfig11,'-dpng','STiGen_mid.png')
    print(hfig12,'-dpng','STiGen_least.png') 
end 