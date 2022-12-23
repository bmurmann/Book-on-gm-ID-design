% Fig. 1.11 gm versus W for L = 60 nm and ID = 10 µA
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% data ============
ID = 10e-6;
W = 0.2:1010;

% compute =====================
ID_W = ID./W;
gm_ID = lookup(nch,'GM_ID','ID_W', ID_W);
gm_CGG = lookup(nch,'GM_CGG','ID_W', ID_W);
gm = gm_ID*ID;
gm_W = gm./W';

% plot ===============
h = figure;
semilogx(W, gm*1e3, 'k-', 'linewidth', 1);
xlabel('{\itW} (\mum)')
ylabel('{\itg_m}  (mS)')
axis([min(W) max(W) 0 0.28])
grid;

%format_and_save(h, 'Fig1_11');