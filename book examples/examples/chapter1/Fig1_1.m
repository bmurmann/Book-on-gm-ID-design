% Fig. 1.1 compare JD to strong and weak inversion approximation
clearvars;
close all
addpath ../../lib
load 65nch.mat
 
% data --------------------------
L   = .06;
VGS = (0: .001: 1.2)';
VDS = 1.2;
UT  = .026;
 
% compute ------------------------
JD = lookup(nch,'ID_W','VGS',VGS,'VDS',VDS,'L',L);
 
% EKV ======================
y  = XTRACT(nch,L,VDS,0,.8)
n  = y(2)
VT = y(3)
JS = y(4)
 
% strong inversion ==========
beta = JS/(2*n*UT^2);
GVO  = (VGS-VT);
M    = GVO >=0;
JDsi  = beta*GVO(M).^2/(2*n);
 
% weak inversion ============
Jo  = JS*exp(2 - VT/(n*UT));
JDwi = Jo*exp(VGS/(n*UT));
 
% plot ======================
h1 = figure(1);
semilogy(VGS,JD,'k',VGS(M),JDsi,'k',VGS,JDwi,'k',VT*[1 1],[1e-9 1e-3],'k--');
axis([0 1.2 1e-9 1e-3]); grid
xlabel('{\itV_G_S}   (V)');
ylabel('{\itJ_D}   (A)');
title('{\itJ_D} (+ wi, si approx) for {\itL} = 60 nm, and {\itV_D_S} = 1 V')

%format_and_save(h1, 'Fig1_1')
