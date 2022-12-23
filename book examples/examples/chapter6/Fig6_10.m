% Fig. 6.10 Plot transient simulation results of Ex. 6.2
clearvars;
close all;
addpath ../../lib

% read results
load Fig6_10.mat

% compute
err = (vod(end)-vod)/vod(end);
es = 0.1e-2;
idx = find(err<=es, 1, 'first');
ts = interp1(err(idx-5:idx+5), t(idx-5:idx+5), es, 'pchip')

h = figure;
subaxis(2,1,1,'Spacing', 0.14, 'MarginBottom', 0.14, 'MarginTop', 0.03, 'MarginLeft', 0.13, 'MarginRight', 0.03); 
plot(t/1e-9, vod/1e-3,'k-', 'linewidth', 1)
xlabel({'Time  (ns)'; '(a)'})
ylabel('{\itv_o_d}  (mV)')
axis([0 3 -3 21]);
grid;
g = text(2.25, 18.5, sprintf('%2.2f mV', vod(end)/1e-3));
set(g, 'fontsize', 9);

subaxis(2,1,2)
semilogy(t/1e-9, abs(err)+eps,'k-', ts/1e-9, es, 'ko', 'linewidth', 1);
xlabel({'Time  (ns)'; '(b)'})
ylabel('{\it\epsilon_d}')
set(gca,'YTick', [1e-4 1e-3 1e-2 1e-1 1e0]);
axis([0 3 1e-4 2]);
grid;
set(gca,'YMinorGrid', 'off');
g = text(2.05, 2.5e-3, sprintf('%2.2f ns', ts/1e-9));
set(g, 'fontsize', 9);

%format_and_save(h, 'Fig6_10', 'H', 4)


