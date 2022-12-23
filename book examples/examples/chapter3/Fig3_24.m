% 3.2.1   Active load: (gds/ID)2 versus (gm/ID)2 for various L
clear all
close all
addpath ../../lib
load 65pch.mat


% data ===================
L = .2*(1:5);   % (µm)
gm_ID2 = 3:28;  % (S/A)


% compute ===============
gds_ID2 = lookup(pch,'GDS_ID','GM_ID',gm_ID2,'L',L);


%plot ====================
h = figure(1);
plot(gm_ID2,gds_ID2,'k','linewidth',1); 
axis([2 max(gm_ID2)+1 0 0.5]); 
grid
xlabel('{(\itg_m}/{\itI_D})_2   (S/A)');
ylabel('{(\itg_d_s}/{\itI_D})_2   (S/A)');
text(10,0.14,'{\itL} = 1000 nm', 'fontsize', 9);
text(4,0.41,'{\itL} = 200 nm', 'fontsize', 9);


%format_and_save(h, 'Fig3_24')
