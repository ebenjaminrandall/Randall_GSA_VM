
tic

clear all
close all

load GSA.mat 


VarSi_gen = outputs.gen.varSi; 
VarSTi_gen = outputs.gen.varSTi;
VarY_gen = outputs.gen.varY; 

time = data.time; 
p = length(INDMAP);


%% Centered Window 

% Delta t = 5 uniform
windSize = 5;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end 
            Si_5c(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_5c(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end

% Delta t = 5 gaussian  
windSize = 5;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end             
            Si_5gc(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
            STi_5gc(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
        end
end


% Delta t = 10 uniform
windSize = 10; 
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end 
            Si_10c(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_10c(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end    

% Delta t = 10 gaussian  
windSize = 10;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end             
            Si_10gc(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
            STi_10gc(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
        end
end

% Delta t = 15 uniform 
windSize = 15; 
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end 
            Si_15c(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_15c(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end 

% Delta t = 15 gaussian distribution 
windSize = 15;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end             
            Si_15gc(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
            STi_15gc(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
        end
end

% Delta t = 20 
windSize = 20; 
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end 
            Si_20c(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_20c(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end 

% Delta t = 20 gaussian distribution 
windSize = 20;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize/2
                k = 1; 
            else 
                k = j - round(windSize/2/dt);
            end
            if time(end) - time(j) < windSize/2
                l = length(time); 
            else 
                l = j + round(windSize/2/dt); 
            end             
            Si_20gc(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
            STi_20gc(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*hann(l-k+1,'symmetric'))/trapz(time(k:l),VarY_gen(1,k:l).*hann(l-k+1,'symmetric'));
        end
end

%% Trailing window 

% Delta t = 5
windSize = 5;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j; 
            Si_5t(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_5t(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end

% Delta t = 10 gaussian distribution 
windSize = 5;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j; 
            h = hann(2*(l-k+1),'symmetric'); 
            h2 = h(1:l-k+1); 
            Si_5gt(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
            STi_5gt(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
        end
end

% Delta t = 10 
windSize = 10; 
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j; 
            Si_10t(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_10t(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end    

% Delta t = 10 gaussian distribution 
windSize = 10;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j; 
            h = hann(2*(l-k+1),'symmetric'); 
            h2 = h(1:l-k+1); 
            Si_10gt(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
            STi_10gt(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
        end
end

% Delta t = 15 
windSize = 15; 
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j; 
            Si_15t(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_15t(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end 

% Delta t = 15 gaussian distribution 
windSize = 15;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j; 
            h = hann(2*(l-k+1),'symmetric'); 
            h2 = h(1:l-k+1); 
            Si_15gt(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
            STi_15gt(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
        end
end

% Delta t = 20 
windSize = 20; 
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j; 
            Si_20t(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
            STi_20t(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l))/trapz(time(k:l),VarY_gen(1,k:l));
        end
end 

% Delta t = 20 gaussian distribution 
windSize = 20;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
            else 
                k = j - round(windSize/dt);
            end
            l = j;   
            h = hann(2*(l-k+1),'symmetric'); 
            h2 = h(1:l-k+1); 
            Si_20gt(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
            STi_20gt(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
        end
end

%% Other time-varying indices 

% Generalized Sobol' indices
for i = 1:p
        for j = 2:length(time)
            Si_0(i,j-1)  = trapz(time(1:j), VarSi_gen(i,1:j))/trapz(time(1:j),VarY_gen(1,1:j));
            STi_0(i,j-1) = trapz(time(1:j), VarSTi_gen(i,1:j))/trapz(time(1:j),VarY_gen(1,1:j));
        end
end


% Point-wise Sobol' indices 
Si_pw = VarSi_gen./VarY_gen; 
STi_pw = VarSTi_gen./VarY_gen;

tstart = time(ts); 

save differentwindows.mat 

toc
elapsed_time = toc/60 