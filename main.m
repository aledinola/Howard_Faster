clear
clc
close all

% written by Alessandro Di Nola

%% fun_vfi follows closely the implementation of value function iteration for the
% infinite-horizon model without d variable in the toolkit
% fun_vfi2 changes some loops in the Howard and achieves a 50% speedup
% Note: the speedup is higher the more points for z you have
% RESULTS
% n_a=1000, n_z=7, ratio of new vs old = 0.934
% n_a=1000, n_z=21, ratio of new vs old = 0.81
% n_a=1000, n_z=51, ratio of new vs old = 0.42
% n_a=1000, n_z=101, ratio of new vs old = 0.288

verbose = 1;
 
n_a = 1000;
n_z = 51;

[pi_z,z_grid] = markovapprox(0.9,0.1,0.0,3.0,n_z,0);
z_grid = exp(z_grid);

a_grid = 50*linspace(0,1,n_a).^2;
a_grid = a_grid';

beta = 0.94;
r    = 0.04;
sigma = 2;
w    = 1;

tic
ReturnMat = zeros(n_a,n_a,n_z);

for z_c=1:n_z
    z_val = z_grid(z_c);
    for a_c=1:n_a
        a_val = a_grid(a_c);
        ReturnMat(:,a_c,z_c) = ReturnFn(a_grid,a_val,z_val,r,w,sigma);
    end
end
toc

tic
[V,Policy] = fun_vfi(n_a,n_z,pi_z,ReturnMat,beta,verbose);
time1 = toc

tic
[V2,Policy2] = fun_vfi2(n_a,n_z,pi_z,ReturnMat,beta,verbose);
time2 = toc

diff_1_vs_2 = max(abs(Policy(:)-Policy2(:)))

fprintf('Runtime of new method vs old method: %f \n',time2/time1)

pol_aprime = a_grid(Policy);

figure
plot(a_grid,a_grid,'--')
hold on
plot(a_grid,pol_aprime(:,1))
hold on
plot(a_grid,pol_aprime(:,n_z))


