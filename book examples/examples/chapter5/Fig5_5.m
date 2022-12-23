% Ex. 5.1   Simulated temp sensitivity of constant gm bias
clearvars;
close all;
addpath ../../lib
degC = sprintf('Temperature  (%cC)', char(176));

% Load Spice data
load('Fig5_5.mat')

% Plot
temp_ref = 27;
id2_ref = interp1(temp, id2_nom, temp_ref);
delta_nom = 100*(id2_nom - id2_ref) / id2_ref; 

h = figure(1);
subaxis(2,2,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.1, 'MarginRight', 0.03)
plot(temp, id2_nom, 'k', 'linewidth', 1);
hold on;
plot(temp_ref, id2_ref, 'ko');
xlabel({degC, '(a)'});
ylabel('{\itI_D_2}  (\muA)');
axis([-40 125 40 70]);
grid;

subaxis(2,2,3)
plot(temp, delta_nom, 'k', 'linewidth', 1);
hold on;
plot(temp_ref, 0, 'ko');
xlabel({degC, '(c)'});
ylabel('Deviation  (%)');
axis([-40 125 -20 30]);
grid;

gm2_ref = interp1(temp, gm2_nom, temp_ref);
delta_nom = 100*(gm2_nom - gm2_ref) / gm2_ref; 

subaxis(2,2,2)
plot(temp, gm2_nom, 'k', 'linewidth', 1);
hold on;
plot(temp_ref, gm2_ref, 'ko');
xlabel({degC, '(b)'});
ylabel('{\itg_m_2}  (mS)');
axis([-40 125 0.6 0.8]);
grid;

subaxis(2,2,4)
plot(temp, delta_nom, 'k', 'linewidth', 1);
hold on;
plot(temp_ref, 0, 'ko');
xlabel({degC, '(d)'});
ylabel('Deviation  (%)');
axis([-40 125 -2 2]);
grid;

%format_and_save(h, 'Fig5_5', 'W', 5.2, 'H', 4.6);
