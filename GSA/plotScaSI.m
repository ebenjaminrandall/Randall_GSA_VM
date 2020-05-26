%{
plotScaSI.m
This script plots ranked scalar Sobol' indices of the full model.

It requires 'differentwindows.mat' and 'sens.mat' in the Full Model LSA folder, i.e. it requires
'../FullModel/LSA/sens.mat'.
%}

%Clear workspace
clear all
close all 

%Input
printon = 0; %Print for ranking

%Load data
load differentwindows.mat
load ../FullModel/LSA/sens.mat

%Get ranking
[Rsens,Isens] = sort(sens_norm(1:23),'descend');

%Thresholds
eta1 = 1e-1; 
eta2 = 1e-3;

%% Scalar

%Generate figure
hfig1 = figure(1); 
clf
set(gcf,'units','normalized','outerposition',[0 0.05 .25 .15]);
set(gcf,'renderer','Painters')

h1 = bar([1:length(R_STi)],R_STi/max(R_STi),'b','facealpha',.5); 
hold on
plot([1:length(R_STi)],sens_norm(I_STi)./max(sens_norm),'kx','linewidth',2,'MarkerSize',10);
plot([0 length(R_STi)+1],eta1*ones(2,1),'k--',[0 length(R_STi)+1],eta2*ones(2,1),'k--')
txt = '$\eta_1$'; 
text(length(I_STi)+1,1e-1,txt,'interpreter','latex','FontSize',10)
txt = '$\eta_2$'; 
text(length(I_STi)+1,1e-3,txt,'interpreter','latex','FontSize',10)

set(gca,'FontSize',15)

xlim([0 length(I_STi)+1])
xlabel('Parameters')
Xlabel = params(I_STi); 
Xtick = 1:length(I_STi);
set(gca,'xtick',Xtick)
set(gca,'TickLabelInterpreter','latex')
set(gca,'XTickLabels',Xlabel)

ylim([1e-4 1])
ytick = [1e-4 1e-2 1]; 
set(gca,'Ytick',ytick)
set(gca,'YScale','log')

if printon == 1
    print(hfig1,'-dpng','STi_scalar.png')
    print(hfig1,'-depsc2','-tiff','-r300','-painters','STi_sca.eps')
end

