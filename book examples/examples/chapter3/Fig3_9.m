% Example 3.2   FO, Av0 and W versus L for gm/ID = 15 S/A
clear all
close all
addpath ../../lib
load 65nch.mat

% data ===========================
fu = 1e8;       % (Hz)
CL = 1e-12;     % (F)
gm_ID1 = 15;    % (S/A)

% compute ========================
gm = 2*pi*fu*CL;
ID = gm./gm_ID1

fT = lookup(nch,'GM_CGG','GM_ID', 15,'L',nch.L)/(2*pi)
M  = fT >= 10*fu;
Lmax = max(nch.L(M))
 
Av0 = lookup(nch,'GM_GDS','GM_ID', 15,'L',nch.L(M))
L   = nch.L(M)
fT  = fT(M)

W = ID./lookup(nch,'ID_W','GM_ID', 15,'L',L)

% plot =========================
h = figure(1);
plot(L,Av0(M),'k--',L,W,'k-',L,fT/fu,'k-.', 'linewidth', 1); 
axis([0 max(L) 0 120]); 
grid
xlabel('{\itL}   (µm)')
text(0.4,93,'|{\itA_v_0}|');
text(0.2,17,'{\itW} (µm)');
text(0.1,100,'{\itFO}');

%format_and_save(h, 'Fig3_9')






