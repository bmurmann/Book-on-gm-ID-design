% Fig. A.3.2
clear all;
close all;
addpath ../../lib

W = 0.2:0.01:100;
nfing = max(round(W/2), 1);
Wfing = W./nfing;

h1 = figure(1);
semilogx(W, Wfing, 'k-', 'linewidth', 1)
xlabel('{\itW}  (\mum)')
ylabel('{\itW_f_i_n_g}  (\mum)')

%format_and_save(h1, 'FigA3_2')
