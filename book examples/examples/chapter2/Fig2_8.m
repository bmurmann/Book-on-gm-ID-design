% 2.2.4   compare gm/ID EKV to quadr and exp approx.
clear all
close all
addpath ../../lib
load 65nch.mat
 
% data --------------------------
L   = .06;
VGS = (0: .01: 1.2)';
VDS = 1;
UT  = .026;
 
% compute ------------------------
%JD = lookup(nch,'ID_W','VGS',VGS,'VDS',VDS,'L',L);
 
% EKV ======================
n  = 1.2; 
VT = 0.4; 
JS = 1e-6; 
 
 
% strong inversion ==========
beta = JS/(2*n*UT^2);
GVO  = (VGS-VT);
M    = GVO >=0;
%JDsi  = beta*GVO(M).^2/(2*n);
 
% weak inversion ============
Jo  = JS*exp(2 - VT/(n*UT));
JDwi = Jo*exp(VGS/(n*UT));

% all inversion levels ======
q = logspace(-5,1.5,50);
rho = 1./(1 + q); %JD = JS*(q.^2 + q);
VP = UT*(2*(q-1) + log(q));
VGS_EKV = n*VP + VT;

q1 = [  .2 .5 1 2 5  ];
rho1 = 1./(1 + q1);
VP1 = UT*(2*(q1-1) + log(q1));
VGS_EKV1 = n*VP1 + VT;
 
% plot ======================
h = figure;
plot(VGS_EKV,rho,'k','linewidth', 2); hold
plot(VGS,2*n*UT./(VGS - VT),'k', 'linewidth', 1)
plot([0 1.2],[1 1],'k--', 'linewidth', 1)
plot(VGS_EKV1,rho1,'k+','linewidth',2) 
plot(VT*[1 1],[0 1.2],'k:', 'linewidth', 1);


axis([0 1.2 0 1.2]); 
grid;

text(VGS_EKV1(3)-0.2,rho1(3),'{\itq} = 1', 'fontsize', 9)
text(VGS_EKV1(4)-0.2,rho1(4),'{\itq} = 2', 'fontsize', 9)
text(VGS_EKV1(5)-0.2,rho1(5),'{\itq} = 5', 'fontsize', 9)
text(VGS_EKV1(2)-0.2,rho1(2),'{\itq} = 0.5', 'fontsize', 9)
text(VGS_EKV1(1)-0.2,rho1(1),'{\itq} = 0.2', 'fontsize', 9)


xlabel('{\itV_G}  (V)');
ylabel('{\it\rho}');

g = legend('Basic EKV model', 'Square law', 'Exponential', 'location', 'East');
set(g, 'fontsize', 9);
set(gca, 'yminorgrid', 'off');

%format_and_save(h, 'Fig2_8');



