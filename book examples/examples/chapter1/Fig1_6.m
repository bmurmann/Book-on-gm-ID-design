% Fig. 1.6 gm/ID and gm/W for L = 60 nm (VDS = 1 V and VSB = 0 V)
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% data ===============
L = 0.06;
VDS=1;

% compute ==============
VOV = nch.VGS - lookup(nch, 'VT','L',L,'VDS',VDS);
VOVf = linspace(eps, 0.8);
gm_ID = lookup(nch,'GM_ID','L',L,'VDS',VDS);
gm_W = lookup(nch,'GM_W','L',L,'VDS',VDS);

% plot ====================
h = figure(1);
subaxis(2,1,1, 'Spacing', 0.17, 'MarginBottom', 0.15, 'MarginTop', 0.03, 'MarginLeft', 0.15, 'MarginRight', 0.03)
plot(VOV, gm_ID, 'k-', VOVf, 2./VOVf, 'k--', 'linewidth', 1);
ylabel('{\itg_m}/{\itI_D}  (S/A)')
xlabel({'{\itV_O_V} (V)'; '(a)'})
axis([-0.3 0.8 0 30])
legend('Real device', 'Square law')

s = sprintf('Weak\ninversion');
g = text(-0.25, 5, s);
set(g, 'fontsize', 9);
s = sprintf('Moderate\ninversion');
g = text(0, 5, s);
set(g, 'fontsize', 9);
s = sprintf('Strong\ninversion');
g = text(0.3, 12, s);
set(g, 'fontsize', 9);

subaxis(2,1,2)
plot(VOV, gm_W, 'k-', VOVf, 2.22e-3*VOVf, 'k--', 'linewidth', 1);
ylabel('{\itg_m}/{\itW}  (S/\mum)')
xlabel({'{\itV_O_V} (V)'; '(b)'})
axis([-0.3 0.8 0 1.1e-3])
legend('Real device', 'Square law', 'location', 'northwest')

%format_and_save(h, 'Fig1_6', 'H', 4);