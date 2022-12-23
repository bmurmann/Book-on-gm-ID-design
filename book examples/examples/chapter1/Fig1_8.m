% Fig. 1.8 gm/W versus gm/ID for L = 60 nm
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% data ================
L = 0.06;
VDS=1;

% compute ============
gm_ID = 3:0.1:26;
gm_W = lookup(nch,'GM_W','GM_ID',gm_ID,'L',L,'VDS',VDS);

% plot ================
h = figure(1);
plot(gm_ID, gm_W, 'k-', 'linewidth', 1);
xlabel('{\itg_m}/{\itI_D}  (S/A)')
ylabel('{\itg_m}/{\itW}  (S/\mum)')
axis([2 28 -0.05e-3 1e-3])
grid;

%format_and_save(h, 'Fig1_8');