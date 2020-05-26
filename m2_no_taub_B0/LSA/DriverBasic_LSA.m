%{
DriverBasic_LSA.m
This script performs local sensitivity analysis (LSA) on the m2 reduced
model computed by ../ForwardEvaluation/DriverBasic.

It requires 'nomHR.mat' in the ForwardEvaluation folder, i.e. it requires
'../ForwardEvaluation/nomHR.mat'. 
 
The script performs LSA via finite forward differences (via senseq.m),
generates the sensitivity matrix (via senseq.m), and ranks the Euclidean
norm of the sensitivities.

The sensitivity matrix and rankings are saved in 'sens.mat'.
%}

%Clear workspace
clear all
close all

%Begin timing
tic 
                                
%% Load data  

load ../ForwardEvaluation/nomHR.mat 

echoon  = 0; %Echo for executable status in model solve
printon = 0; %Print for sensitivity ranking

%% Get nominal parameter values

%Global parameters
ODE_TOL  = 1e-8;
DIFF_INC = sqrt(ODE_TOL);

gpars.ODE_TOL  = ODE_TOL;
gpars.DIFF_INC = DIFF_INC; 
gpars.echoon = echoon;

data.gpars = gpars; 

%% Sensitivity Analysis

%senseq finds the non-weighted sensitivities
sens = senseq(pars,data);

sens = abs(sens); 

%ranked classical sensitivities
[M,N] = size(sens);
for i = 1:N 
    sens_norm(i)=norm(sens(:,i),2);
end

%sens_norm = sens_norm(1:end-2); 
[Rsens,Isens] = sort(sens_norm,'descend');
display([Isens]); 

params = {'$A$', ...
    '$K_{pb}$','$K_{pr}$','$K_s$', ...
    '$\tau_{pb}$','$\tau_{pr}$','$\tau_s$','$\tau_H$',...
    '$q_w$','$q_{pb}$','$q_{pr}$','$q_{s}$', ...
    '$s_w$','$s_{pb}$','$s_{pr}$','$s_{s}$', ...
    '$H_I$','$H_{pb}$','$H_{pr}$','$H_{s}$', ...
    '$D_s$'}; 

%Save sensitivity results
save sens.mat

%% Plots

%Thresholds
eta1 = 1e-1; 
eta2 = 1e-3; 

%Ranked sensitivities
hfig1 = figure(1);
clf
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'renderer','Painters')
set(gca,'FontSize',25)
h=bar([1:length(Rsens)],Rsens./max(Rsens),'b','facealpha',.5);
hold on 
xlim([0 length(Isens)+1])
ylabel('Ranked LSA')
xlabel('Parameters')
%title('Ranked Relative Sensitivities')
Xtick = 1:length(Isens);
set(gca,'xtick',Xtick)
set(gca,'TickLabelInterpreter','latex')
Xlabel = params(Isens); 
set(gca,'XTickLabels',Xlabel)
set(gca,'YScale','log')
set(gca,'XTickLabels',Xlabel)
ylim([1e-6 1])
ytick = [1e-6 1e-3 1]; 
set(gca,'Ytick',ytick)
hold on
set(gca,'FontSize',25)
plot([0 length(Rsens)+1],eta1*ones(2,1),'k--',[0 length(Rsens)+1],eta2*ones(2,1),'k--')
txt = '$\eta_1$'; 
text(24,8e-2,txt,'interpreter','latex','FontSize',40)
txt = '$\eta_2$'; 
text(24,8e-4,txt,'interpreter','latex','FontSize',40)

%Print figure
if printon == 1
    print(hfig1,'-depsc2','LSA.eps')
    print(hfig1,'-dpng','LSA.png') 
end

%End timing
elapsed_time = toc
