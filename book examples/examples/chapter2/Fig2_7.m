% 2.2.3   compare JD EKV to quadr and exp approx.
clear all
close all
addpath ../../lib
load 65nch.mat
 
% data --------------------------
L   = .06;
VGS = (0: .001: 1.2)';
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
JDsi  = beta*GVO(M).^2/(2*n);
 
% weak inversion ============
Jo  = JS*exp(2 - VT/(n*UT));
JDwi = Jo*exp(VGS/(n*UT));

% all inversion levels ======
q = logspace(-5,1.5,50);
JD = JS*(q.^2 + q);
VP = UT*(2*(q-1) + log(q));
VGS_EKV = n*VP + VT;

q1 = [  .2 .5 1 2 5  ];
JD1 = JS*(q1.^2 + q1);
VP1 = UT*(2*(q1-1) + log(q1));
VGS1_EKV = n*VP1 + VT;
 
% plot ======================
h = figure;
semilogy(VGS_EKV,JD,'k', 'linewidth', 1.5);
hold on;
semilogy(VGS(M),JDsi,'k',VGS,JDwi,'k--')
semilogy(VT*[1 1],[1e-9 1e-3],'k:', 'linewidth', 1);
semilogy(VGS1_EKV,JD1,'k+','linewidth',1.5);
semilogy(VT*[1 1],[1e-9 1e-3],'k:', 'linewidth', 1);

axis([0 1.2 1e-9 1e-3]); 
grid;
text(VGS1_EKV(1)-0.2,JD1(1),'{\itq} = 0.2', 'fontsize', 9)
text(VGS1_EKV(2)-0.2,JD1(2),'{\itq} = 0.5', 'fontsize', 9)
text(VGS1_EKV(3)-0.2,JD1(3)*1.2,'{\itq} = 1', 'fontsize', 9)
text(VGS1_EKV(4)-0.02,JD1(4)*3.5,'{\itq} = 2', 'fontsize', 9)
text(VGS1_EKV(5)-0.05,JD1(5)*2.2,'{\itq} = 5', 'fontsize', 9)

xlabel('{\itV_G}  (V)');
ylabel('{\itJ_D}  (A/\mum)');
g = legend('Basic EKV model', 'Square law', 'Exponential', 'location', 'southeast');
set(g, 'fontsize', 9);
set(gca, 'yminorgrid', 'off');

%format_and_save(h, 'Fig2_7');

