% Fig. A.2.2
clearvars;
close all
addpath ../../lib
load 65pch.mat
load 65nch.mat
 
gm_IDo = 28;
gm_ID = lookup(pch,'GM_ID', 'VGS', pch.VGS, 'VSB', 0.6, 'L', 0.2);
gm_Cgg = lookup(pch,'GM_CGG', 'VGS', pch.VGS, 'VSB', 0.6, 'L', 0.2);
wT = interp1(gm_ID, gm_Cgg, gm_IDo)

[m, idx] = max(gm_ID)
wT = interp1(gm_ID(idx:end), gm_Cgg(idx:end), gm_IDo)
VGSo = interp1(gm_ID(idx:end), pch.VGS(idx:end), gm_IDo)
VGSx = interp1(gm_ID(1:idx), pch.VGS(1:idx), gm_IDo)

h = figure;
subaxis(2,1,1,'Spacing', 0.15, 'MarginBottom', 0.15, 'MarginTop', 0.03, 'MarginLeft', 0.11, 'MarginRight', 0.03); 
plot(nch.VGS, gm_ID, 'k-', [0 1.2], [gm_IDo gm_IDo], 'k:', VGSx, gm_IDo, 'kx', VGSo, gm_IDo, 'ko', 'linewidth', 1.1, 'markersize', 8)
xlabel({'pch.V_G_S  (V)'; '(a)'});
ylabel('gm\_ID  (S/A)');

subaxis(2,1,2)
plot(nch.VGS(idx:end), gm_ID(idx:end), 'k-', [0 1.2], [gm_IDo gm_IDo], 'k:', VGSo, gm_IDo, 'ko', nch.VGS(idx), m, 'k^', 'linewidth', 1.1, 'markersize', 8)
xlabel({'pch.V_G_S  (V)'; '(b)'});
ylabel('gm\_ID  (S/A)');
text(0.25, 36, 'Maximum', 'fontsize', 9)

%format_and_save(h, 'FigA2_2', 'H', 4.5);