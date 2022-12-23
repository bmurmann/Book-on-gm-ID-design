%4.3.2   standard deviation of current mirror mismatch
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

AVT = 3.5e-9;
WL1 = 10*0.06e-12;
WL2 = 100*0.06e-12;
gm_ID = 5:0.1:25;
sigma1 = gm_ID*AVT/sqrt(WL1);
sigma2 = gm_ID*AVT/sqrt(WL2);

VGS = 0:0.01:0.8;
gmid = lookup(nch,'GM_ID', 'VGS', VGS);
sigma1a = gmid*AVT/sqrt(WL1);
sigma2a = gmid*AVT/sqrt(WL2);

h = figure;
subaxis(1,2,1, 'Spacing', 0.11, 'MarginBottom', 0.2, 'MarginTop', 0.04, 'MarginLeft', 0.1, 'MarginRight', 0.03)
plot(gm_ID, 100*sigma1, 'k', gm_ID, 100*sigma2, 'k--', 'linewidth', 1);
xlabel({'{\itg_m}/{\itI_D}  (S/A)', '(a)'})
ylabel('stdev({\it\DeltaI_D}/{\itI_D_1})  (%)')
grid;

subaxis(1,2,2)
plot(VGS, 100*sigma1a, 'k', VGS, 100*sigma2a, 'k--', 'linewidth', 1);
xlabel({'{\itV_G_S}  (V)', '(b)'})
ylabel('stdev({\it\DeltaI_D}/{\itI_D_1})  (%)')
grid;

%format_and_save(h, 'Fig4_32', 'W', 5.3);
