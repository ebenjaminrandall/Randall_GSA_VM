
tic

load GSA.mat 

VarSi_gen = outputs.gen.varSi; 
VarSTi_gen = outputs.gen.varSTi;
VarY_gen = outputs.gen.varY; 

time = data.time; 
p = length(INDMAP);


% Delta t = 15 gaussian distribution 
windSize = 15;
for i = 1:p
        for j = 2:length(time)
            if time(j)-time(1) < windSize
                k = 1; 
                l = round(windSize/dt); 
            else 
                k = j - round(windSize/dt);
                l = j; 
            end
            h = hann(2*(l-k+1),'symmetric'); 
            h2 = h(1:l-k+1); 
            Si_15gt(i,j-1)  = trapz(time(k:l), VarSi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
            STi_15gt(i,j-1) = trapz(time(k:l), VarSTi_gen(i,k:l).*h2)/trapz(time(k:l),VarY_gen(1,k:l).*h2);
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

save trailingGaussianwindow.mat 

toc
elapsed_time = toc/60 