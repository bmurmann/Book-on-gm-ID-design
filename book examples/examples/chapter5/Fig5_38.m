% 5.6.2   fT across corners for 2 biasing scenarios
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
wT = lookup(nch, 'GM_CGG', 'ID_W', ID_W, 'L', L);
fT = wT/2/pi;
fT_slow_hot = lookup(nch_slow_hot, 'GM_CGG', 'ID_W', ID_W, 'L', L)/2/pi;
fT_fast_cold = lookup(nch_fast_cold, 'GM_CGG', 'ID_W', ID_W, 'L', L)/2/pi;
delta_slow = 100*(fT_slow_hot - fT)./fT;
delta_fast = 100*(fT_fast_cold - fT)./fT;

h = figure(1);
subaxis(2,2,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.06, 'MarginLeft', 0.1, 'MarginRight', 0.02)
semilogx(ID_W, fT/1e9, 'k', 'linewidth', 2)
t=title('Constant {\itI_D}')
set(t, 'fontsize', 9, 'fontweight', 'normal')
hold on;
semilogx(ID_W, fT_slow_hot/1e9, 'k:', 'linewidth', 1)
semilogx(ID_W, fT_fast_cold/1e9, 'k--', 'linewidth', 1)
xlabel({'{\itI_D}/{\itW}  (A/\mum)', '(a)'});
ylabel('{\itf_T}  (GHz)');
axis([0.5e-6 max(ID_W) 0 80])
set(gca, 'xtick', [1e-6 1e-5 1e-4]);
legend('Nom.', 'Slow, hot', 'Fast, cold', 'Location', 'NorthWest')
grid;
set(gca, 'xminorgrid', 'off');

subaxis(2,2,3)
semilogx(ID_W, delta_slow, 'k:', 'linewidth', 1)
hold on;
semilogx(ID_W, delta_fast, 'k--', 'linewidth', 1)
axis([0.5e-6 max(ID_W) -30 30])
set(gca, 'xtick', [1e-6 1e-5 1e-4]);
xlabel({'{\itI_D}/{\itW}  (A/\mum)', '(c)'});
ylabel('Difference (%)');
grid;
set(gca, 'xminorgrid', 'off');


%---------------------------------------------------
% constant gm
gm_W = lookup(nch, 'GM_W', 'GM_ID', gm_ID, 'L', L);
wT = lookup(nch, 'GM_CGG', 'GM_W', gm_W, 'L', L);
fT = wT/2/pi;
fT_slow_hot = lookup(nch_slow_hot, 'GM_CGG', 'GM_W', gm_W, 'L', L)/2/pi;
fT_fast_cold = lookup(nch_fast_cold, 'GM_CGG', 'GM_W', gm_W, 'L', L)/2/pi;
delta_slow = 100*(fT_slow_hot - fT)./fT;
delta_fast = 100*(fT_fast_cold - fT)./fT;

subaxis(2,2,2)
semilogx(gm_W, fT/1e9, 'k', 'linewidth', 2)
t=title('Constant {\itg_m}')
set(t, 'fontsize', 9, 'fontweight', 'normal')
hold on;
semilogx(gm_W, fT_slow_hot/1e9, 'k:', 'linewidth', 1)
semilogx(gm_W, fT_fast_cold/1e9, 'k--', 'linewidth', 1)
ylabel('{\itf_T}  (GHz)');
xlabel({'{\itg_m}/{\itW}  (S/\mum)', '(b)'});
axis([1e-5 1.2*max(gm_W) 0 80])
set(gca, 'xtick', [1e-5 1e-4 1e-3]);
grid;
set(gca, 'xminorgrid', 'off');

subaxis(2,2,4)
semilogx(gm_W, delta_slow, 'k:', 'linewidth', 1)
hold on;
semilogx(gm_W, delta_fast, 'k--', 'linewidth', 1)
axis([1e-5 1.2*max(gm_W) -30 30])
set(gca, 'xtick', [1e-5 1e-4 1e-3]);
xlabel({'{\itg_m}/{\itW}  (S/\mum)', '(d)'});
ylabel('Difference (%)');
grid;
set(gca, 'xminorgrid', 'off');

%format_and_save(h, 'Fig5_38', 'W', 5.3, 'H', 5)
