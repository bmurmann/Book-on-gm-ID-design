% Example 3.11
clearvars;
close all
addpath ../../lib

% Plot Spice results
load('Fig3_32.mat')
fu_sim = exp(interp1(log(vout), log(f), 0));
Avo_sim = vout(1);

h1 = figure(1);
loglog(f, vout, 'k', fu_sim, 1, 'ko', 'linewidth', 1);
hold on;
loglog(f, ones(1,length(f)), 'k:');
xlabel('{\itf}  (Hz)');
ylabel('|{\itA_v}|');
axis([1e4 0.5e11 0.1 20]);
text(0.5e5, 13, num2str(Avo_sim, '%1.2f'), 'fontsize', 9);
text(1.6e9, 1.3,  [num2str(fu_sim*1e-9, '%1.3f') ' GHz'], 'fontsize', 9);
set(gca, 'xtick', [1e4 1e5 1e6 1e7 1e8 1e9 1e10]);

%format_and_save(h1, 'Fig3_32')


