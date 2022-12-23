% 4.1.4   simulated input referred flicker noise density  
clearvars;
close all;
addpath ../../lib

% Constants
k = 1.3806488e-23;
T = 300;
gamma = 0.8;

% Spice data
load('Fig4_9.mat')

% Model equation
a = 1.3;
n0 = 50;
flickmod = n0*(1 + a./gm_id);

% plot
h = figure;
plot(gm_id, nspot*1e9, 'k-', gm_id, flickmod, 'k--', 'linewidth', 1);
xlabel('{\itg_m}/{\itI_D}  (S/A)');
ylabel('Input noise  (nV/rt-Hz)');
axis([5 28 20 65]);
legend('SPICE', 'Model equation', 'location', 'southeast')
grid;

%format_and_save(h, 'Fig4_9')
