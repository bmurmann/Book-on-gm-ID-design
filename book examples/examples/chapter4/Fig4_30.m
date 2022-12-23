% Ex. 4.6   SPICE simulation of HD3 versus VDS (vpk = 10 mV)
clearvars;
close all;
addpath ../../lib

% Load Spice data
load('Fig4_30.mat')

h = figure;
hold on;
plot(VDS, hd2_db(1,:), 'k-', 'linewidth', 1)
plot(VDS, hd2_db(2,:), 'k:', 'linewidth', 1)
plot(VDS, hd2_db(3,:), 'k--', 'linewidth', 1)
ylabel('{HD_2}  (dB)')
xlabel('{\itV_D_S}  (V)')
grid;
legend('Nominal {\itR}', '-10%', '+10%', 'location', 'north')

%format_and_save(h, 'Fig4_30')
    
    
    
    
    
    