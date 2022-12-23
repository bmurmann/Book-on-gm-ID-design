% Ex. 5.8   simulated frequency resp and input noise versus frequency
clearvars;
close all;
addpath ../../lib

% Load Spice data
load('Fig5_34.mat')
magdb = 20*log10(vo);
gaindb_sim = max(magdb);
fc = interp1(magdb, f, gaindb_sim-3, 'spline');
magdb_fc = interp1(f, magdb, fc, 'spline');
noise_at_fc = interp1(f1, noise, 3e9, 'spline');

% Plot
h = figure;
subaxis(2,1,1,'Spacing', 0.14, 'MarginBottom', 0.14, 'MarginTop', 0.02, 'MarginLeft', 0.14, 'MarginRight', 0.02); 
semilogx(f, magdb,'k-', fc, magdb_fc, 'ko', 'linewidth', 1)
xlabel({'Frequency  (Hz)', '(a)'})
ylabel('|{\itv_o}/{\itv_t_e_s_t}|  (dB)')
axis([1e7 1e11 -22 -3]);
grid;
set(gca,'XMinorGrid', 'off');
g = text(2e7, -7.2, sprintf('%2.2f dB', gaindb_sim));
set(g, 'fontsize', 8);
g = text(4.3e9, -11, sprintf('%2.2f GHz', fc/1e9));
set(g, 'fontsize', 8);

subaxis(2,1,2)
loglog(f1, noise/1e-12,'k-', 3e9, noise_at_fc/1e-12, 'ko', 'linewidth', 1)
xlabel({'Frequency  (Hz)', '(b)'})
ylabel('Input noise (pA/rt-Hz)')
grid;
set(gca,'XMinorGrid', 'off');
set(gca,'YMinorGrid', 'off');
axis([1e7 1e11 0.1 1000]);
g = text(4.5e9, 40, sprintf('%2.1f pA/rt-Hz', noise_at_fc/1e-12));
set(g, 'fontsize', 8);

%format_and_save(h, 'Fig5_34', 'H', 4.5)


