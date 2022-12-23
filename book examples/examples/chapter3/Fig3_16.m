% 3.1.5   Sizing in weak inv:  Avo and fT vesus JD  
clear all
close all
addpath ../../lib
load 65nch.mat

% data ==============
L = [0.06 0.1 0.2 0.5 1];   % (µm)


% compute ===================
JD     = lookup(nch,'ID_W','VGS',nch.VGS,'L',L);
gm_ID  = lookup(nch,'GM_ID','VGS',nch.VGS,'L',L);
gm_gds = lookup(nch,'GM_GDS','VGS',nch.VGS,'L',L);
fT     = lookup(nch,'GM_CGG','VGS',nch.VGS,'L',L)/2/pi;



% plot ===========================
h = figure(1);

subaxis(2,1,1, 'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.03, 'MarginLeft', 0.15, 'MarginRight', 0.03)
semilogx(JD', gm_gds','k','linewidth',1);  
grid; 
axis([1e-11 1e-4 0 250]);
xlabel({'{\itJ_D}  (A/µm)'; '(a)'});
ylabel('{\itg_m}/{\itg_d_s}');
g = text(1e-9, 225, '{\itL} = 1000 nm');
set(g, 'fontsize', 9);
g = text(1e-9, 40, '{\itL} = 100 nm');
set(g, 'fontsize', 9);
g = text(5e-9, 20, '{\itL} = 60 nm');
set(g, 'fontsize', 9);

subaxis(2,1,2)
loglog(JD', fT','k','linewidth',1);  
grid; 
axis([1e-11 1e-4 1e4 1e12]);
xlabel({'{\itJ_D}  (A/µm)'; '(b)'});
ylabel('{\itf_T}  (Hz)');
g = text(1e-6, 1e11, '{\itL} = 60 nm');
set(g, 'fontsize', 9);
g = text(1e-9, 3e5, '{\itL} = 1000 nm');
set(g, 'fontsize', 9);



%format_and_save(h, 'Fig3_16', 'H', 5.5)


