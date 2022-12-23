% 2.3.3   VT versus VDS, param L
clear all;
close all;
addpath ../../lib
load 65nch.mat;


% data ======================
VDS = (.2: .025: 1.2)';
L   = [.06 .08 .1 .15 .25  1];


% compute ===================
for k = 1:length(L),
    y  = XTRACT(nch,L(k),VDS,0); size(y)
    VT(:,k) = y(:,3);      % VT(VDS,L)
end


% plot ======================
z = figure(1);

plot(VDS,VT,'k','linewidth', 1); 
axis([0 1.2 .45 .55]); grid
xlabel('{\itV_D_S}  (V)'); ylabel('{\itV_T}  (V)');

text(.05,1.02*VT(1,1),'{\itL}  (\mum)', 'fontsize', 9)
for k = 1:length(L),
    text(.05,VT(1,k),sprintf('%0.2f',L(k)), 'fontsize', 9)
end

VT([13 17 21 25 29 33],:); % verif

%format_and_save(z, 'Fig2_18')


