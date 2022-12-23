% Example 2.3      compare EKV reconstructed gm/ID to real
clear all;
close all;
addpath ../../lib
load 65nch.mat;

% data -------------------
L   = 0.1;
VDS = [.6 .9 1.2]';

% -- CSM ----------
gm_ID= lookup(nch, 'GM_ID','VDS',VDS,'L',L); 
JD = lookup(nch,'ID_W','VDS',VDS,'L',L);

% -- EKV model ----- 
% EKV extract param =================
y  = XTRACT(nch,L,VDS,0);    % [length(VDS  6]
n  = y(:,2); VT = y(:,3); IS = y(:,4);

    
N = 50; q  = logspace(-6,1,N);
UT = .026; 
VP = UT*(2*(q-1) + log(q));

gm_Id = 1./(n*(1+q)*UT);
VG = n*VP + VT(:,ones(1,N));
Id = IS*(q.^2 + q);
    

% plot ----------------
h = figure(1);
subaxis(1,2,1,'Spacing', 0.12, 'MarginBottom', 0.2, 'MarginTop', 0.03, 'MarginLeft', 0.1, 'MarginRight', 0.03); 
plot(nch.VGS,gm_ID,'k-', VG', gm_Id','k--', 'linewidth', 1); 
grid; axis([0 1.2 0 35]);
xlabel({'{\itV_G_S}  (V)'; '(a)'}); ylabel('{\itg_m}/{\itI_D}  (S/A)');

subaxis(1,2,2);
plot(log10(JD),gm_ID,'k-',log10(Id)',gm_Id','k--', 'linewidth', 1); axis([-10 -2 0 35]); 
xlabel({'log_1_0({\itJ_D} (A/µm))';'(b)'}); ylabel('{\itg_m}/{\itI_D}  (S/A)');
grid

%format_and_save(h, 'FIG2_14', 'W', 5.3, 'H', 3)


