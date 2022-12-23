% 3.1.5   Sizing in weak inv: gm/ID versus JD
clear all
close all
addpath ../../lib
load 65nch.mat

% data ==============
L = [0.06 0.1 0.2 0.5 1];   % (µm)


% compute =================
JD     = lookup(nch,'ID_W','VGS',nch.VGS,'L',L);
gm_ID  = lookup(nch,'GM_ID','VGS',nch.VGS,'L',L);
gm_gds = lookup(nch,'GM_GDS','VGS',nch.VGS,'L',L);


% plot ====================
h = figure(1);
semilogx(JD', gm_ID','k','linewidth',1); 
grid; 
axis([1e-11 1e-4 5 35]);
ylabel('{\itg_m}/{\itI_D}  (S/A)');
xlabel('{\itJ_D}  (A/µm)');
text(0.2e-9, 27.5, '{\itL} = 60 nm', 'fontsize', 9);
text(1e-6, 28, '{\itL} = 100 nm', 'fontsize', 9);
text(5e-8, 12, '{\itL} = 1000 nm', 'fontsize', 9);
text(0.25e-9, 7, ' 4 nA/\mum', 'fontsize', 9);
g = line([4e-9 4e-9], [0 40]);
set(g, 'color', 'k', 'linestyle', ':', 'linewidth', 1);


%format_and_save(h, 'Fig3_15')

