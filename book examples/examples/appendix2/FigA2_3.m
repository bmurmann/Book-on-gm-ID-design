% Fig. A.2.3
clearvars;
close all
addpath ../../lib
load 65pch.mat
load 65nch.mat
 
gm_Cgg = lookup(nch,'GM_CGG', 'VGS', nch.VGS);
[m, idx] = max(gm_Cgg)

h = figure;
plot(nch.VGS(1:idx), gm_Cgg(1:idx), 'k-', nch.VGS(idx:end), gm_Cgg(idx:end), 'k:', nch.VGS(idx), m, 'k^', 'linewidth', 1.1, 'markersize', 8)
xlabel('nch.VGS  (V)');
ylabel('gm\_Cgg  (rad/s)');

%format_and_save(h, 'FigA2_3');