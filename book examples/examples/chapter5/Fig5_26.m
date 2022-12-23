% Ex. 5.5   simulated distortion at 100 MHz  
clearvars;
close all;
addpath ../../lib

% Load Spice results
load('Fig5_26.mat')
first_line = adbm - adbm(1) + first(1);
second_line = 2*(adbm - adbm(1)) + second(1);
p1db_x = interp1(first_line-first, adbm, 1);
p1db_y = interp1(adbm, first, p1db_x);
first_30 = interp1(adbm, first, -30);
second_30 = interp1(adbm, second, -30);

h = figure(1);
plot(adbm, first, 'k', 'linewidth', 2);
hold on;
plot(adbm, second, 'k', 'linewidth', 1);
plot(adbm, first_line, 'k--', adbm, second_line, 'k--', 'linewidth',1);
plot(p1db_x, p1db_y, 'ko');
plot(-30, first_30, 'ko', -30, second_30, 'ko')
xlabel('Input power (dBm)');
ylabel('Output power (dBm)');
set(gca, 'xtick', -40:10:20)
grid;

j = legend('Fundamental', 'Second harmonic', 'location', 'southeast');
set(j, 'FontSize', 8);
j = text(p1db_x-3, p1db_y+14, '\itP_1_d_B');
set(j, 'FontSize', 9);
j = text(-30-3, first_30+13, sprintf('%2.1f', first_30));
set(j, 'FontSize', 9);
j = text(-30-3, second_30-13, sprintf('%2.1f', second_30));
set(j, 'FontSize', 9);
g = title(sprintf('P_1_d_B=%2.1f dBm, IIP2=%2.1f dBm', p1db_x, 37.7));
set(g, 'fontsize', 9, 'fontweight', 'normal')

%format_and_save(h, 'Fig5_26');
