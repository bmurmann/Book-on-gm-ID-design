% 4.1.4   noise integral
clearvars;
close all;
addpath ../../lib

% Constants
k = 1.3806488e-23;
T = 300;
gamma = 0.8;

% Spice data
load('Fig4_10.mat')
integ1 = sqrt(cumtrapz(f, nspot1.^2));
integ2 = sqrt(cumtrapz(f, nspot2.^2));
integ3 = sqrt(cumtrapz(f, nspot3.^2));

h = figure(1);
semilogx(f, integ1*1e6, 'k--', f, integ2*1e6, 'k-', 'linewidth', 1);
hold on;
semilogx(f, integ3*1e6, 'k-', 'linewidth', 2);
legend('Thermal noise', 'Flicker noise', 'Total noise', 'location', 'northwest')
xlabel('Frequency  (Hz)');
ylabel('Integrated input noise  (\muV)');
axis([1e3 1e10 0 15]);

hl = line(1.22e6*[1 1], [0 5]);
set(hl, 'lineStyle', ':', 'linewidth', 1);
set(hl, 'Color', 'k');
ht = text(1.5e6, 4, '\itf_c_o');
set(ht, 'FontSize', 9);
grid;

%format_and_save(h, 'Fig4_10')

