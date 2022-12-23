% 2.3.8   (parasitic cap)/Cgg versus gm/ID for L = 0.1 and 1 micron
clear all;
close all;
addpath ../../lib
load 65nch.mat;

UGS = .2: .025: .8;

% ===============
L = .1;
ID1 = lookup(nch,'ID','VGS',UGS,'L',L);
gm1 = lookup(nch,'GM','VGS',UGS,'L',L);
gmID1 = gm1./ID1;
Cgg = lookup(nch,'CGG','VGS',UGS,'L',L);
Cgs = lookup(nch,'CGS','VGS',UGS,'L',L)./Cgg;
Cgb = lookup(nch,'CGB','VGS',UGS,'L',L)./Cgg;
Cgd = lookup(nch,'CGD','VGS',UGS,'L',L)./Cgg;
h = figure(1);
subaxis(1,2,1,'Spacing', 0.08, 'MarginBottom', 0.2, 'MarginTop', 0.05, 'MarginLeft', 0.1, 'MarginRight', 0.03); 

plot(gmID1,Cgs,'k-',gmID1,Cgb,'k.-',gmID1,Cgd,'k--','linewidth', 1); 

xlabel({'{\itg_m}/{\itI_D}  (S/A)';'(a)'}); axis([0 30 0 1]); grid
text(8,Cgs(18)+ .05,'{\itC_g_s}/{\itC_g_g}', 'fontsize', 9)
text(8,Cgb(18)+.08,'{\itC_g_b}/{\itC_g_g}', 'fontsize', 9)
text(8,Cgd(18)+.08,'{\itC_g_d}/{\itC_g_g}', 'fontsize', 9)

% ================
L = 1;
ID2 = lookup(nch,'ID','VGS',UGS,'L',L);
gm2 = lookup(nch,'GM','VGS',UGS,'L',L);
gmID2 = gm2./ID2;
Cgg = lookup(nch,'CGG','VGS',UGS,'L',L);
Cgs = lookup(nch,'CGS','VGS',UGS,'L',L)./Cgg;
Cgb = lookup(nch,'CGB','VGS',UGS,'L',L)./Cgg;
Cgd = lookup(nch,'CGD','VGS',UGS,'L',L)./Cgg;
subaxis(1,2,2);
plot(gmID2,Cgs,'k-',gmID2,Cgb,'k.-',gmID2,Cgd,'k--','linewidth', 1); 

xlabel({'{\itg_m}/{\itI_D}  (S/A)';'(b)'}); axis([0 30 0 1]); grid
text(8,Cgs(18)+ .05,'{\itC_g_s}/{\itC_g_g}', 'fontsize', 9)
text(13,Cgb(10)+.12,'{\itC_g_b}/{\itC_g_g}', 'fontsize', 9)
text(20,Cgd(3)+.03,'{\itC_g_d}/{\itC_g_g}', 'fontsize', 9)


%format_and_save(h, 'Fig2_27', 'W', 5.3)