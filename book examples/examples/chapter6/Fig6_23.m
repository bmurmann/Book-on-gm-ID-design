% Fig. 6.23 Plot SPICE noise results from Ex. 6.6
clearvars;
close all;
addpath ../../lib

% read results
load Fig6_23.mat

% compute
noise_integral = sqrt(cumtrapz(f, noise.^2));

h = figure;
subaxis(2,1,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.14, 'MarginRight', 0.04)
loglog(f, noise/1e-9,'k-', 'linewidth', 1)
xlabel({'Frequency (Hz)'; '(a)'})
ylabel('Output noise (nV/rt-Hz)')
grid;
set(gca,'XMinorGrid', 'off');
set(gca,'YMinorGrid', 'off');
set(gca,'YTick', [1e-2 1e-1 1e0 1e1]);
axis([1e6 1e11 1e-2 1e2]);

subaxis(2,1,2)
semilogx(f, noise_integral/1e-6,'k-', 'linewidth', 1)
xlabel({'Frequency (Hz)'; '(b)'})
ylabel('Output noise integral (\muV)')
grid;
set(gca,'XMinorGrid', 'off');
set(gca,'YMinorGrid', 'off');
axis([1e6 1e11 0 500]);
text(1.2e10, 430, [sprintf('%2.1f %s', noise_integral(end)/1e-6) '\muV'], 'fontsize', 9);

%format_and_save(h, 'Fig6_23', 'H', 4.8)

