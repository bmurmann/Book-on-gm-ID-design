% Ex. 5.1   Simulated VDD sensitivity of constant gm bias
clearvars;
close all;
addpath ../../lib

% Load Spice data
load('Fig5_6.mat')

% Plot
h = figure;

vdd_ref = 1.2;
id2_ref = interp1(vdd, id2_nom, vdd_ref);
delta_nom = 100*(id2_nom - id2_ref) / id2_ref; 

subaxis(2,2,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.1, 'MarginRight', 0.03)
plot(vdd, id2_nom, 'k', 'linewidth', 1);
hold on;
plot(vdd_ref, id2_ref, 'ko');
xlabel({'{\itV_D_D}  (V)', '(a)'});
ylabel('{\itI_D_2}  (\muA)');
axis([1.05 1.35 45 55]);
grid;

subaxis(2,2,3)
plot(vdd, delta_nom, 'k', 'linewidth', 1);
hold on;
plot(vdd_ref, 0, 'ko');
xlabel({'{\itV_D_D}  (V)', '(c)'});
ylabel('Deviation (%)');
axis([1.05 1.35 -10 10]);
grid;

gm2_ref = interp1(vdd, gm2_nom, vdd_ref);
delta_nom = 100*(gm2_nom - gm2_ref) / gm2_ref; 

subaxis(2,2,2)
plot(vdd, gm2_nom, 'k', 'linewidth', 1);
hold on;
plot(vdd_ref, gm2_ref, 'ko');
xlabel({'{\itV_D_D}  (V)', '(b)'});
ylabel('{\itg_m_2}  (mS)');
axis([1.05 1.35 0.65 0.8]);
grid;

subaxis(2,2,4)
plot(vdd, delta_nom, 'k', 'linewidth', 1);
hold on;
plot(vdd_ref, 0, 'ko');
xlabel({'{\itV_D_D}  (V)', '(d)'});
ylabel('Deviation (%)');
axis([1.05 1.35 -10 10]);
grid;

%format_and_save(h, 'Fig5_6', 'W', 5.2, 'H', 4.6);














