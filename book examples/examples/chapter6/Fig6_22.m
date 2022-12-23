% Fig. 6.22 Plot SPICE transient results from Ex. 6.6
clearvars;
close all;
addpath ../../lib

% read results
load Fig6_22.mat

% compute
err = (vod(end)-vod)/vod(end);
es = 0.1e-2;
idx = find(err<=es, 1, 'first');
ts = interp1(err(idx-5:idx+5), t(idx-5:idx+5), es, 'pchip');

h = figure;
subaxis(2,1,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.14, 'MarginRight', 0.04)
plot(t/1e-9, vod/1e-3,'k-', 'linewidth', 1)
xlabel({'Time (ns)'; '(a)'})
ylabel('{\itv_o_d}  (mV)')
axis([0 7 -3 21]);
grid;
text(5.8, 18, sprintf('%2.2f mV', vod(end)/1e-3), 'fontsize', 9);

subaxis(2,1,2)
semilogy(t/1e-9, abs(err)+eps,'k-', ts/1e-9, es, 'ko', 'linewidth', 1);
xlabel({'Time (ns)'; '(b)'})
ylabel('{\it\epsilon_d}')
set(gca,'YTick', [1e-4 1e-3 1e-2 1e-1 1e0]);
axis([0 7 1e-4 2]);
grid;
set(gca,'YMinorGrid', 'off');
text(5.4, 2.5e-3, ['{\itt_s=}' sprintf('%2.2f ns', (ts/1e-9)-1)], 'fontsize', 9);

%format_and_save(h, 'Fig6_22', 'H', 4.8)


