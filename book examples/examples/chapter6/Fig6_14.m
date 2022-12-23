% Figure 6.14 SPICE transient response plot for Ex. 6.3
clearvars;
close all;
addpath ../../lib

% read results
load Fig6_14.mat

% compute
vod = vop-vom;
err = (vod(end)-vod)/vod(end);
ed = 0.1e-2;
idx = find(err<=ed, 1, 'first');
ts = interp1(err(idx-5:idx+5), t(idx-5:idx+5), ed, 'pchip')

vid = vip-vim;
gm_id = 19.9;
vslew = 2/gm_id;
ID = 2.56e-3;
SR = 2.48;
tslew = 0.175;

h = figure;
subaxis(2,1,1,'Spacing', 0.15, 'MarginBottom', 0.15, 'MarginTop', 0.03, 'MarginLeft', 0.13, 'MarginRight', 0.03)
plot(t/1e-9, vod/1e-3,'k-', ts/1e-9, vod(idx)/1e-3, 'ko')
xlabel({'Time (ns)'; '(a)'})
ylabel('{\itv_o_d} (mV)')
axis([0.8 2.3 -100 880]);
grid;
g = text(1.95, 675, strcat('{\itt_s}', sprintf(' = %2.2f ns', (ts/1e-9)-1)));
set(g, 'fontsize', 9);

subaxis(2,1,2)
plot(t(2:end)/1e-9, diff(vod)./diff(t)/1e9, 'k-')
xlabel({'Time (ns)'; '(b)'})
ylabel('{\itdv_o_d}/{\itdt}  (V/ns)')
axis([0.8 2.3 0 4]);
grid;

g = line([1 1+tslew], [1 1]*SR);
set(g, 'color', 'k', 'linewidth', 2, 'linestyle', '-');
g = line([1+tslew 1+tslew], [1 0]*SR);
set(g, 'color', 'k', 'linewidth', 2, 'linestyle', '-');
g = text(1.18, SR, '\leftarrow Computed {\itSR} and {\itt_s_l_e_w}')
set(g, 'fontsize', 9);

%format_and_save(h, 'Fig6_13', 'H', 3.8)
















