

printon = 1; 

%% Window figures 

t = 0:.1:30; 

y1 = zeros(size(t)); 
x = t >= 5 & t < 25; 
y1(x) = 1; 

y2 = zeros(size(t)); 
h = hann(length(t(x))*2); 
h2 = h(1:length(h)/2); 
y2(x) = h2; 

tlims = [-1 30]; 
ylims = [-0.05 1.1];

ttick = [0 10 20 30]; 
ytick = [0 0.5 1]; 

fontsize = 30; 

hfig1 = figure(1);
clf
plot(tlims,zeros(2,1),'k','linewidth',.5)
hold on 
plot(zeros(2,1),ylims,'k','linewidth',.5)
plot(t,y1,'b','linewidth',1)
xlim(tlims)
ylim(ylims)
set(gca,'Xtick',ttick)
set(gca,'Ytick',ytick)
set(gca,'FontSize',fontsize)
xlabel('Time (s)')

hfig2 = figure(2);
clf
plot(tlims,zeros(2,1),'k','linewidth',.5)
hold on 
plot(zeros(2,1),ylims,'k','linewidth',.5)
plot(t,y2,'b','linewidth',1)
xlim(tlims)
ylim(ylims)
set(gca,'Xtick',ttick)
set(gca,'Ytick',ytick)
set(gca,'FontSize',fontsize)
xlabel('Time (s)')


if printon == 1
    print(hfig1,'-depsc2','uniform.eps')
    print(hfig2,'-depsc2','halfgaussian.eps')
end 

%% 

load differentwindowstest.mat 

printon = 1; 

fontsize = 30; 

ttick = [0 30 60];
y1tick = [0.3 0.45 0.6]; 
y2tick = [80:20:140];

tlims = [0 60];
y1lims = [0.25 0.65];
y2lims = [65 150]; 

tsVM = Tnew(ts);
t1 = Tnew(k_SPendI);
t2 = Tnew(k_SPminII);
teVM = Tnew(te); 
trVM = Tnew(tr); 
t4VM = Tnew(t4); 

x1   = [tsVM t1 t1 tsVM];
x2   = [t1 teVM teVM t1]; 
x3   = [teVM trVM trVM teVM];
x4   = [trVM t4VM t4VM trVM]; 

y1   = [y1lims(1) y1lims(1) y1lims(2) y1lims(2)]; 

% Uniform vs Hanning
hfig3 = figure(3); 
clf
plot(time(2:end),STi_15t(23,:),'k')
hold on 
plot(time(2:end),STi_15gt(23,:),'r')
set(gca,'ytick',y1tick)
ylim(y1lims)
set(gca,'xtick',ttick)
xlim(tlims)
set(gca,'FontSize',fontsize)
xlabel('Time (s)')

yyaxis right 
plot(Tdata,Hdata,'b','linewidth',1)
ylabel('HR (bpm)')
set(gca,'ytick',y2tick)
ylim(y2lims)
set(gca,'ycolor','k')
set(gca,'xcolor','k')


% Different window sizes 
hfig4 = figure(4); 
clf
hold on 
plot(time,STi_pw(23,:),'Color',[0 0 1])
plot(time(2:end),STi_5gt(23,:),'Color',[0.2 0 1])
plot(time(2:end),STi_10gt(23,:),'Color',[.4 0 1])
plot(time(2:end),STi_15gt(23,:),'Color',[0.6 0 1])
plot(time(2:end),STi_20gt(23,:),'Color',[0.8 0 1])
plot(time(2:end),STi_0(23,:),'Color',[1 0 1])
set(gca,'ytick',y1tick)
ylim(y1lims)
set(gca,'xtick',ttick)
xlim(tlims)
set(gca,'FontSize',fontsize)
xlabel('Time (s)')
set(gca,'ycolor','k')

yyaxis right 
plot(Tdata,Hdata,'b','linewidth',1)
ylabel('HR (bpm)')
set(gca,'ytick',y2tick)
ylim(y2lims)
set(gca,'ycolor','k')
set(gca,'xcolor','k')


if printon == 1
    print(hfig3,'-depsc2','univsgauss.eps')
    print(hfig4,'-depsc2','diffwindows.eps')
end 






































