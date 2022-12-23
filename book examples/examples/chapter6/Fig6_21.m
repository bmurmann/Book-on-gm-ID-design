% Fig. 6.21 Plot SPICE loop gain results from Ex. 6.6
clearvars;
close all;
addpath ../../lib

% read results
load Fig6_21.mat

% compute
mag = abs(real + 1i*imag);
magdb = 20*log10(mag);
phase = unwrap(angle(real + 1i*imag))*180/pi + 180;
fu = interp1(magdb, f, 0, 'spline');
pm = interp1(f, phase, fu)+180;
DC_loopgain = 10^(max(magdb)/20)

h = figure;
subaxis(2,1,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.14, 'MarginRight', 0.04)
semilogx(f, magdb,'k-', fu, 0, 'ko', 'linewidth', 1)
xlabel({'Frequency (Hz)'; '(a)'})
ylabel('|Loop gain|  (dB)')
axis([1e4 1e10 -20 50]);
grid;
set(gca,'XMinorGrid', 'off');
text(5e4, 44, sprintf('%2.2f dB', max(magdb)), 'fontsize', 9);
text(350e6, 5, sprintf('%2.2f MHz', fu/1e6), 'fontsize', 9);

subaxis(2,1,2)
semilogx(f, phase,'k-', fu, pm-180, 'ko', 'linewidth', 1)
ylabel('Phase (^{\circ})')
xlabel({'Frequency (Hz)'; '(b)'})
axis([1e4 1e10 -180 0]);
grid;
text(150e6, -80, [sprintf('PM = %2.2f', pm) '^{\circ}'], 'fontsize', 9);

%format_and_save(h, 'Fig6_21', 'H', 4.8)

