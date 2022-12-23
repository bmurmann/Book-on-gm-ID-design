% 5.6.2   VDsat across corners for 2 biasing scenarios
clearvars;
close all;
addpath ../../lib
load 65nch_slow_hot.mat
nch_slow_hot = nch;
load 65nch_fast_cold.mat
nch_fast_cold = nch;
load 65nch.mat

L = 0.1;
gm_ID = (5.5:0.1:28)';

%---------------------------------------------------
% constant ID
ID_W = lookup(nch, 'ID_W', 'GM_ID', gm_ID, 'L', L);
gm_ID_slow_hot = lookup(nch_slow_hot, 'GM_ID', 'ID_W', ID_W, 'L', L);
gm_ID_fast_cold = lookup(nch_fast_cold, 'GM_ID', 'ID_W', ID_W, 'L', L);
delta_slow = 1000*(2./gm_ID_slow_hot - 2./gm_ID);
delta_fast = 1000*(2./gm_ID_fast_cold - 2./gm_ID);

h = figure(1);
subaxis(2,2,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.06, 'MarginLeft', 0.1, 'MarginRight', 0.02)
semilogx(ID_W, 1000*2./gm_ID, 'k', 'linewidth', 2)
t=title('Constant {\itI_D}')
set(t, 'fontsize', 9, 'fontweight', 'normal')
hold on;
semilogx(ID_W, 1000*2./gm_ID_slow_hot, 'k:', 'linewidth', 1)
semilogx(ID_W, 1000*2./gm_ID_fast_cold, 'k--', 'linewidth', 1)
xlabel({'{\itI_D}/{\itW} (A/\mum)', '(a)'});
ylabel('{\itV_D_s_a_t}  (mV)');
axis([0.5e-6 max(ID_W) 0 700])
set(gca, 'xtick', [1e-6 1e-5 1e-4]);
legend('Nom.', 'Slow, hot', 'Fast, cold', 'Location', 'NorthWest')
grid;
set(gca, 'xminorgrid', 'off');

subaxis(2,2,3)
semilogx(ID_W, delta_slow, 'k:', 'linewidth', 1)
hold on;
semilogx(ID_W, delta_fast, 'k--', 'linewidth', 1)
axis([0.5e-6 max(ID_W) -200 200])
set(gca, 'xtick', [1e-6 1e-5 1e-4]);
xlabel({'{\itI_D}/{\itW} (A/\mum)', '(c)'});
ylabel('Difference (%)');
grid;
set(gca, 'xminorgrid', 'off');

%---------------------------------------------------
% constant gm
gm_W = lookup(nch, 'GM_W', 'GM_ID', gm_ID, 'L', L);
gm_ID_slow_hot = lookup(nch_slow_hot, 'GM_ID', 'GM_W', gm_W, 'L', L);
gm_ID_fast_cold = lookup(nch_fast_cold, 'GM_ID', 'GM_W', gm_W, 'L', L);
delta_slow = 1000*(2./gm_ID_slow_hot - 2./gm_ID);
delta_fast = 1000*(2./gm_ID_fast_cold - 2./gm_ID);

subaxis(2,2,2)
semilogx(gm_W, 1000*2./gm_ID, 'k', 'linewidth', 2)
t=title('Constant {\itg_m}')
set(t, 'fontsize', 9, 'fontweight', 'normal')
hold on;
semilogx(gm_W, 1000*2./gm_ID_slow_hot, 'k:', 'linewidth', 1)
semilogx(gm_W, 1000*2./gm_ID_fast_cold, 'k--', 'linewidth', 1)
xlabel({'{\itg_m}/{\itW}  (S/\mum)', '(b)'});
ylabel('{\itV_D_s_a_t}  (mV)');
axis([1e-5 1.2*max(gm_W) 0 700])
set(gca, 'xtick', [1e-5 1e-4 1e-3]);
grid;
set(gca, 'xminorgrid', 'off');

subaxis(2,2,4)
semilogx(gm_W, delta_slow, 'k:', 'linewidth', 1)
hold on;
semilogx(gm_W, delta_fast, 'k--', 'linewidth', 1)
axis([1e-5 1.2*max(gm_W) -200 200])
set(gca, 'xtick', [1e-5 1e-4 1e-3]);
xlabel({'{\itg_m}/{\itW}  (S/\mum)', '(d)'});
ylabel('Difference (%)');
grid;
set(gca, 'xminorgrid', 'off');

%format_and_save(h, 'Fig5_37', 'W', 5.3, 'H', 5)
