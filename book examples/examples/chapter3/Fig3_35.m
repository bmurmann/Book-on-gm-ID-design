% Fig. 3.35 (Example 3.12)
clearvars;
close all;
addpath ../../lib

% Spice results
load('Fig3_35.mat')

% Find annotation values
fu_sim = exp(interp1(log(vout), log(f), 0));
Avo_sim = vout(1);

h1 = figure(1);
loglog(f, vout, 'k', fu_sim, 1, 'ko', 'linewidth', 1);
hold on;
loglog(f, ones(1,length(f)), 'k:');
xlabel('{\itf}  (Hz)');
ylabel('|{\itA_v}|');
axis([1e4 0.5e11 0.01 40]);
text(0.5e5, 22.5, num2str(Avo_sim, '%1.2f'), 'fontsize', 9);
text(1.45e8, 1.5,  [num2str(fu_sim*1e-6, '%1.1f') ' MHz'], 'fontsize', 9, 'backgroundcolor', [1 1 1]);
text(2e9, 0.07, sprintf('Pole-zero\ndoublet'), 'fontsize', 9);
set(gca, 'xtick', [1e4 1e5 1e6 1e7 1e8 1e9 1e10]);

%format_and_save(h1, 'Fig3_35')


