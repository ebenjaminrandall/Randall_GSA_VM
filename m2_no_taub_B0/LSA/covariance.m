%{
covariance.m
Using sensitivity matrix computed in DriverBasic_LSA.m, identifies pairwise
correlations between parameters and returns sensitive and linearly 
independent parameter subset.

It requires 'sens.mat' 
%}

%Clear workspace
clear all 

%Load sensitivity matrix
load sens.mat 

%Update parameter index vector
INDMAP = [5 6 18 19 20]

%Extract proper columns of sensitivity matrix
S = sens(:,INDMAP);

%Model Hessian
A  = S'*S;
Ai = inv(A);
disp('condition number of A = transpose(S)S and S');
disp([ cond(A) cond(S) cond(Ai)] );

%Calculate the covariance matrix
[a,b] = size(Ai);
for i = 1:a
    for j = 1:b
        r(i,j)=Ai(i,j)/sqrt(Ai(i,i)*Ai(j,j)); % covariance matrix
    end
end

%Determine correlated parameters
tol = .9;                  %tolerance
rn = triu(r,1)             %extract upper triangular part of the matrix
[i,j] = find(abs(rn)>tol); %parameters with a value bigger than 0.9
                           %are correlated

%Display the correlate parameters
disp('correlated parameters');

for k = 1:length(i)
   disp([INDMAP(i(k)),INDMAP(j(k)),rn(i(k),j(k))]);
end
disp(Isens)
