% Ex. 5.4   Spice verification of NF
clearvars;
close all;
addpath ../../lib

% Load Spice data
load('Fig5_23.mat')
nf_calculated = 2.30;

h = figure(1);
semilogx(f, nf, 'k', f, nf_calculated*ones(length(f),1), 'k--', 'linewidth',1);
xlabel('Frequency  (Hz)');
ylabel('{\itNF}  (dB)');
grid;
j = legend('SPICE', 'Matlab', 'location', 'southeast');
set(j, 'FontSize', 8);
axis([1e6 1e10 0 5]);
set(gca, 'xtick', [1e6 1e7 1e8 1e9 1e10])

%format_and_save(h, 'Fig5_23');
