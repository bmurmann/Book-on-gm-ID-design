% 2.3.3   VT versus L,  param VDS
clear all;
close all;
addpath ../../lib
load 65nch.mat;
% load 65nch_fast_cold.mat
% load 65nch_slow_hot.mat


% data ====================
L   = .01*[(6:20) (25:5:100)];
VDS = (0.5: .1: 1)';

% EKV param extraction algorithm ==================
for k  = 1:length(L)
    y  = XTRACT(nch,L(k),VDS,0);
    VT(:,k) = y(:,3);   % VTo(VDS,L)
end



% plot -------------------------
h = figure(1); 
semilogx(L,VT,'k','linewidth', 1);
grid
xlabel('{\itL}  (\mum)'); 
ylabel('{\itV_T}  (V)');
axis([1e-2 1 0.46 0.51]);

Lmin = min(L);
text(.2,VT(1,1),'{\itV_D_S}  (V)', 'fontsize', 9)
for k = 1:length(VDS),
    text(.5*Lmin,VT(k,1),sprintf('%0.2f',VDS(k)), 'fontsize', 9)
end

%format_and_save(h, 'Fig2_17')

