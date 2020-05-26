

clear all
close all 

load optHR.mat 

echoon = 0; 
data.gpars.echoon = echoon; 

[~,lb,ub] = load_global(data); 

Hlims = [40 160]; 
ytick = 40:40:160; 
Tlims = [0 60]; 
xtick = [0 30 60]; 

n = 200; 

%% q_w 

figure(1)
clf
set(gcf,'renderer','Painters')

p = pars_LM;

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

q_w = ones(n,1)*lb(12) + s(1:n,1)*(ub(12) - lb(12)); 

for i = 1:length(q_w) 
    p(12) = q_w(i); 
    
    HR = model_sol(p,data); 
    
    figure(1)
    hold on 
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s q_w
    
%% s_s 

figure(2)
clf
set(gcf,'renderer','Painters')

p = pars_LM; 

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

s_s = ones(n,1)*lb(19) + s(1:n,1)*(ub(19) - lb(19)); 

for i = 1:length(s_s) 
    p(19) = s_s(i); 
    
    HR = model_sol(p,data); 
    
    figure(2)
    hold on  
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s s_s

%% B

figure(3)
clf
set(gcf,'renderer','Painters')

p = pars_LM; 

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

B = ones(n,1)*lb(2) + s(1:n,1)*(ub(2) - lb(2)); 

for i = 1:length(B) 
    p(2) = B(i); 
    
    HR = model_sol(p,data); 
    
    figure(3)
    hold on 
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s B

%% s_pb

figure(4)
clf
set(gcf,'renderer','Painters')

p = pars_LM; 

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

s_pb = ones(n,1)*lb(17) + s(1:n,1)*(ub(17) - lb(17)); 


for i = 1:length(s_pb) 
    p(17) = s_pb(i); 
    
    HR = model_sol(p,data); 
    
    figure(4)
    hold on
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s s_pb

%% tau_s 

figure(5)
clf
set(gcf,'renderer','Painters')

p = pars_LM; 

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

tau_s = ones(n,1)*lb(10) + s(1:n,1)*(ub(10) - lb(10)); 

for i = 1:length(tau_s) 
    p(10) = tau_s(i); 
    
    HR = model_sol(p,data); 
    
    figure(5)
    hold on  
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s tau_s

%% tau_H

figure(6)
clf 
set(gcf,'renderer','Painters')

p = pars_LM; 

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

tau_H = ones(n,1)*lb(11) + s(1:n,1)*(ub(11) - lb(11)); 

for i = 1:length(tau_H) 
    p(11) = tau_H(i); 
    
    HR = model_sol(p,data); 
    
    figure(6)
    hold on  
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s tau_H

%% tau_pb

figure(7)
clf 
set(gcf,'renderer','Painters')

p = pars_LM; 

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

tau_pb = ones(n,1)*lb(8) + s(1:n,1)*(ub(8) - lb(8)); 

for i = 1:length(tau_pb) 
    p(8) = tau_pb(i); 
    
    HR = model_sol(p,data); 
    
    figure(7)
    hold on
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s tau_pb

%% tau_b

figure(8)
clf 
set(gcf,'renderer','Painters')

p = pars_LM; 

s = sobolset(n); 
s = scramble(s,'MatousekAffineOwen');

tau_b = ones(n,1)*lb(7) + s(1:n,1)*(ub(7) - lb(7)); 

for i = 1:length(tau_b) 
    p(7) = tau_b(i); 
    
    HR = model_sol(p,data); 
    
    figure(8)
    hold on 
    plot(time,HR,'c','linewidth',5)
    
end 

clear p s tau_b

%% Make plots 

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

print(hfig1,'-depsc2','-tiff','-r300','q_w.eps')
print(hfig2,'-depsc2','-tiff','-r300','s_s.eps')
print(hfig3,'-depsc2','-tiff','-r300','B.eps')
print(hfig4,'-depsc2','-tiff','-r300','s_pb.eps')
print(hfig5,'-depsc2','-tiff','-r300','tau_s.eps')
print(hfig6,'-depsc2','-tiff','-r300','tau_H.eps')
print(hfig7,'-depsc2','-tiff','-r300','tau_pb.eps')
print(hfig8,'-depsc2','-tiff','-r300','tau_b.eps')

