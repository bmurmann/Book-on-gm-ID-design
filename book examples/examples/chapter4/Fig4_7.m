% 4.1.4   flicker noise corner
clearvars;
close all;
addpath ../../lib

% data ================
k = 1.3806488e-23;
T = 300;
gamma = 0.8;

% Load Spice data
load('Fig4_7.mat');

% plot ====================
h = figure(4);
loglog(f, nspot1*1e9, 'k--', f, nspot2*1e9, 'k-'); 
hold on;
loglog(f, nspot3*1e9, 'k-', 'linewidth', 2);
xlabel('{\itf}  (Hz)');
ylabel('Input noise  (nV/rt-Hz)');
axis([1e3 1e11 0.1 30]);
legend('Thermal noise', 'Flicker noise', 'Total noise')

hl = line(1.22e6*[1 1], [0.1 nspot1(1)*1e9]);
set(hl, 'lineStyle', ':');
set(hl, 'Color', 'k');
ht = text(0.35e6, 0.15, '\itf_c_o');
set(ht, 'FontSize', 9);

%format_and_save(h, 'Fig4_7')
