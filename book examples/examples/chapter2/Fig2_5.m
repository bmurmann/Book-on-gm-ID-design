% 2.2.1   universal EKV characteristic.
clear all
close all
addpath ../../lib
load 65nch.mat

% data ========
T = 300;

% compute -------------
kB = 1.38e-23; qe = 1.602e-19; UT = kB*T/qe;
qs = logspace(-4,2,100);
i = qs.^2 + qs;
VP = UT*(2*(qs-1) + log(qs));

D = 1./(UT*(qs + 1));

h = figure(1);
subaxis(2,1,1, 'Spacing', 0.13,'MarginBottom', .13, 'MarginTop', .03,'MarginLeft', .13, 'MarginRight', .03); 
semilogy(VP,i,'k','linewidth', 1)
axis([-.3 1.2 1e-4 1e3]); grid
xlabel({'{\itV_P}   (V)';'(a)'});
ylabel('{\iti}');
set(gca, 'ytick', 10.^(-4:2:3));

subaxis(2,1,2); plot(VP,D,'k','linewidth', 1)
axis([-.3 1.2 0 40]); grid
xlabel({'{\itV_P}  (V)';'(b)'});
ylabel('d{\itlog(i}) / d({\itV_P})');

%format_and_save(h, 'FIG2_05', 'H', 5)