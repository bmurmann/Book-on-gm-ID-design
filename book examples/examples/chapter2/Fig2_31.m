% 2.3.8   fT versus L, param gm/ID
clear all
close all
addpath ../../lib
load 65nch.mat


% data ====================
L = .06:0.01:.3;


% compute =================
fT = lookup(nch,'GM_CGG','GM_ID',5:5:20,'L',L)/(2*pi);


% lot =====================
h = figure(1);
plot(1e3*L,fT*1e-9,'k','linewidth',1); 
xlabel('{\itL}  (nm)'); ylabel('{\itf_T}  (GHz)'); grid
text(100,80,'{\itg_m/I_D} = 5 S/A', 'fontsize', 9)
text(110,35,'10 S/A', 'fontsize', 9)
text(90,23,'15 S/A', 'fontsize', 9)
text(60,16,'20 S/A', 'fontsize', 9)

%format_and_save(h, 'Fig2_31')
