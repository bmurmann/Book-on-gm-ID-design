% Ex. 5.5   simulated NF of minimal HD2 LNA
clearvars;
close all;
addpath ../../lib

% Spice data
load('Fig5_25.mat')
nf_calculated = 2.29;

h = figure;
semilogx(f, nf, 'k', f, nf_calculated*ones(length(f),1), 'k--', 'linewidth',1);
xlabel('Frequency (Hz)');
ylabel('{\itNF} (dB)');
grid;
j = legend('SPICE', 'Matlab', 'location', 'southeast');
set(j, 'FontSize', 8);
axis([1e6 1e10 0 5]);
set(gca, 'xtick', [1e6 1e7 1e8 1e9 1e10])

%format_and_save(h, 'Fig5_25');
