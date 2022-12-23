% 4.1.4  simulated input-referred noise density
clear all;
close all;
addpath ../../lib

% data ==============
k = 1.3806488e-23;
T = 300;
gamma = 0.8;

% Load Spice data
load('Fig4_8.mat')

% plot
h = figure;
loglog(f, nspot*1e9, 'k-', 'linewidth', 1);
xlabel('{\itf}  (Hz)');
ylabel('Input noise  (nV/rt-Hz)');
axis([1e3 1e11 1 200]);
grid;

%format_and_save(h, 'Fig4_8')
