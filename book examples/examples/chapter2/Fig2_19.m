% 2.3.3   JS versus VDS, param L
clearvars;
close all;
addpath ../../lib
load 65nch.mat

% data =================
VGS = .1: .025: .8;
VDS = (.2: .025: 1.2)';
VBS = 0;
L   = [.06 .1 .15 .25];



% compute ==============
UT = .026;
ID = lookup(nch, 'ID_W', 'VGS', VGS, 'VDS', VDS, 'L',L); % id(VDS,VGS,L)
W = 10;
for k  = 1:length(L),
    y  = XTRACT(nch,L(k),VDS,VBS); 
    n  = y(:,2);
    JS(:,k) = 10*y(:,4); 
end

% plot =================
z = 23; % legend position
h = figure(1); plot(VDS,JS,'k','linewidth', 1); 
axis([0 1.5 1e-5 1e-4]); grid; 
xlabel('{\itV_D_S}  (V)'); ylabel('{\itJ_S}  (A/\mum)');

text(1.20,.95*JS(z),'{\itL}  (\mum)', 'fontsize', 9)
for k = 1:length(L),
    text(1.25,JS(length(VDS),k),sprintf('%0.2f',L(k)), 'fontsize', 9)
end



%format_and_save(h, 'Fig2_19')

