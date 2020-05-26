%{
plotLSA.m
This script plots the sensitivity ranking computed DriverBasic_LSA.m.

It requires 'sens.mat'.
%}

%Inputs
printon = 0; %Print for sensitivity rankings

%Load sensitivities
load sens.mat 

%Ranking the sensitivities
[Rsens,Isens] = sort(sens_norm(1:23),'descend');

%Thresholds
eta1 = 1e-1; 
eta2 = 1e-3; 

%Ranked sensitivities
hfig1 = figure(1);
clf
set(gcf,'units','normalized','outerposition',[0 0 .45 .3]);
set(gcf,'renderer','Painters')

h=bar([1:length(Rsens)],Rsens./max(Rsens),'b','facealpha',.5);
hold on 
plot([0 length(Rsens)+1],eta1*ones(2,1),'k--',[0 length(Rsens)+1],eta2*ones(2,1),'k--')
txt = '$\eta_1$'; 
text(length(Isens)+1,1e-1,txt,'interpreter','latex','FontSize',10)
txt = '$\eta_2$'; 
text(length(Isens)+1,1e-3,txt,'interpreter','latex','FontSize',10)

set(gca,'FontSize',10)

xlim([0 length(Isens)+1])
xlabel('Parameters')
Xlabel = params(Isens); 
Xtick = 1:length(Isens);
set(gca,'xtick',Xtick)
set(gca,'TickLabelInterpreter','latex')
set(gca,'XTickLabels',Xlabel)

ylim([1e-4 1])
ylabel('Ranked LSA')
ytick = [1e-4 1e-2 1]; 
set(gca,'Ytick',ytick)
set(gca,'YScale','log')
set(gca,'XTickLabels',Xlabel)

%Print figures
if printon == 1
    print(hfig1,'-depsc2','LSA.eps')
    print(hfig1,'-dpng','LSA.png') 
end
