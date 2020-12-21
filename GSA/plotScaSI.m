
clear all
%close all 

load differentwindowstest.mat
load ../FullModel/LSA/sens.mat

[Rsens,Isens] = sort(sens_norm(1:23),'descend');

eta1 = 1e-1; 
eta2 = 1e-3;

%% Scalar

hfig1 = figure(1); 
clf
set(gcf,'units','normalized','outerposition',[0 0.05 .2 .1]);
set(gcf,'renderer','Painters')

h1 = bar([1:length(R_STi)],R_STi/max(R_STi),'b','facealpha',.5); 
hold on
plot([1:length(R_STi)],sens_norm(I_STi)./max(sens_norm),'kx','linewidth',2,'MarkerSize',10);
plot([0 length(R_STi)+1],eta1*ones(2,1),'k--',[0 length(R_STi)+1],eta2*ones(2,1),'k--')
txt = '$\eta_1$'; 
text(length(I_STi)+1,1e-1,txt,'interpreter','latex','FontSize',10)
txt = '$\eta_2$'; 
text(length(I_STi)+1,1e-3,txt,'interpreter','latex','FontSize',10)
%legend(h1,'S_{Ti}')

set(gca,'FontSize',8)

xlim([0 length(I_STi)+1])
xlabel('Parameters')
Xlabel = params(I_STi); 
Xtick = 1:length(I_STi);
set(gca,'xtick',Xtick)
set(gca,'TickLabelInterpreter','latex')
set(gca,'XTickLabels',Xlabel)

ylim([1e-6 1])
%ylabel('Total Sobol'' Indices')
ytick = [1e-6 1e-3 1]; 
set(gca,'Ytick',ytick)
set(gca,'YScale','log')


% axes('position',[.6 .6 .25 .15])
% box on 
% set(gcf,'renderer','Painters')
% h1 = bar([1:5],R_STi(1:5),'b','facealpha',.5); 
% hold on 
% h2 = bar([1:5],abs(Si(I_STi(1:5))),'w','barwidth',.6);
% Xtick = 1:length(I_STi(1:5));
% set(gca,'xtick',Xtick)
% set(gca,'TickLabelInterpreter','latex')
% Xlabel = params(I_STi(1:5)); 
% set(gca,'XTickLabels',Xlabel)
% set(gca,'FontSize',25)
% % set(gca,'yscale','log')
% ytick = 1e0; 
% set(gca,'ytick',ytick)
% legend(h2,'S_{i}')

% npars = 8; 
% axes('position',[.6 .3 .25 .25])
% set(gcf,'renderer','Painters')
% box on 
% h1 = bar([1:npars],R_STi(end-npars+1:end)/max(R_STi),'b','facealpha',.5); 
% Xtick = 1:length(I_STi(end-7:end));
% set(gca,'xtick',Xtick)
% set(gca,'TickLabelInterpreter','latex')
% Xlabel = params(I_STi(end-npars+1:end)); 
% set(gca,'XTickLabels',Xlabel)
% set(gca,'FontSize',40)
% hold on
% plot([0 npars+1],eta2*ones(2,1),'k--')
% ytick = [0 .5e-3 1e-3 1.5e-3];
% %set(gca,'ytick',ytick)
% %ylim([0 1.5e-3])
% set(gca,'YScale','log')
% txt = '$\eta_2$'; 
% text(8,.0009,txt,'interpreter','latex','FontSize',40) 

print(hfig1,'-dpng','STi_scalar.png')
print(hfig1,'-depsc2','-tiff','-r300','-painters','STi_sca.eps')

