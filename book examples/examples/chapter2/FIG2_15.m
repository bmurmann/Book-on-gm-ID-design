% 2.3.1   gm/ID deep in W.I. 
clear all
close all
addpath ../../lib
load 65pch.mat


% data =================
L = .2;        
VSB = .6;


% VGS   -->  gm/ID =======
gm_IDp = lookup(pch,'GM_ID','VGS',pch.VGS,'VSB',VSB,'L',L);
[a b] = max(gm_IDp);
UGS   = pch.VGS(b);


% gm/ID  -->  VGS ==========
gm_ID = 3:2:31;
VGS = lookupVGS(pch,'GM_ID',gm_ID,'VSB',VSB,'L',L);

fT  = lookup(pch,'GM_CGG','GM_ID', gm_ID, 'VSB',VSB, 'L',L)/(2*pi);
Av0 = lookup(pch,'GM_GDS','GM_ID', gm_ID, 'VSB',VSB, 'L',L);


% plot ==========
h = figure(1); 
plot(pch.VGS,gm_IDp,'k',UGS,a,'ko','linewidth',1); grid;
xlabel('{|\itV_G_S}|  (V)');
ylabel('{\itg_m}/{\itI_D}  (S/A)')

%format_and_save(h, 'Fig2_15')