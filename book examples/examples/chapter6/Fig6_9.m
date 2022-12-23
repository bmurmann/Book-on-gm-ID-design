% Fig. 6.9 Plot ac simulation results of Ex. 6.2
clearvars;
close all;
addpath ../../lib

% read simulation results
load Fig6_9.mat

% compute
magdb = 20*log10(vod);
gaindb_sim = max(magdb);
fc = interp1(magdb, f, gaindb_sim-3, 'spline');
magdb_fc = interp1(f, magdb, fc);
noise_integral = sqrt(cumtrapz(f1, noise.^2));

h = figure;
subaxis(3,1,1,'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.03, 'MarginLeft', 0.15, 'MarginRight', 0.03); 
semilogx(f, magdb,'k-', fc, magdb_fc, 'ko', 'linewidth', 1)
xlabel({'Frequency (Hz)'; '(a)'})
ylabel('|{\itv_o}/{\itv_s}|  (dB)')
axis([1e6 1e11 -15 9]);
grid;
set(gca,'XMinorGrid', 'off');
g = text(2e6, 6.55, sprintf('%2.2f dB', gaindb_sim));
set(g, 'fontsize', 9);
g = text(1.5e9, 2, sprintf('%2.2f GHz', fc/1e9));
set(g, 'fontsize', 9);

subaxis(3,1,2)
loglog(f1, noise/1e-9,'k-', 'linewidth', 1)
xlabel({'Frequency (Hz)'; '(b)'})
ylabel('Output noise (nV/rt-Hz)')
grid;
set(gca,'XMinorGrid', 'off');
set(gca,'YMinorGrid', 'off');
set(gca,'YTick', [1e-2 1e-1 1e0 1e1]);
axis([1e6 1e11 1e-2 1e1]);
set(g, 'fontsize', 9);

subaxis(3,1,3)
semilogx(f1, noise_integral/1e-6,'k-', 'linewidth', 1)
xlabel({'Frequency (Hz)'; '(c)'})
ylabel('Output noise integral (\muV)')
grid;
set(gca,'XMinorGrid', 'off');
set(gca,'YMinorGrid', 'off');
axis([1e6 1e11 0 100]);
g = text(1.6e10, 78, [sprintf('%2.1f %s', noise_integral(end)/1e-6) '\muV']);
set(g, 'fontsize', 9);

%format_and_save(h, 'Fig6_9', 'H', 5)

