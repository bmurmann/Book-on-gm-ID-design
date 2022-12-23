% 4.2.1   HD2 and HD3 versus gm/ID for various vgs_pk
clear all;
close all;
addpath ../../lib
load 65nch.mat;

% data ==========================
L   = 1;
VGS = nch.VGS;
VDS = 0.6;

% compute ================
id = lookup(nch,'ID','VDS',VDS,'L',L);

% EKV ---------------
UT = .026;
y   = XTRACT(nch,L,VDS,0);  %extracts EKV para n, VTo and IS

n   = y(2);

q      = logspace(-2,1,50);
gmID   = 1./(n*UT*(1+q));

v = .01*(1:3); 
for k = 1:length(v),
    u = v(k);
    HD2(k,:) = 1/4*gmID.*(1 + q)./(1 + 2*q).*u;         
    HD3(k,:) = 1/24*gmID.^2.*(1 + q).^2./(1 + 2*q).^3.*u.^2;
end


% plot
h = figure(1);
plot(gmID,20*log10(HD2(1,:)),'k-', 'linewidth',1); 
hold on;
plot(gmID,20*log10(HD2(2,:)),'k--', 'linewidth',1); 
plot(gmID,20*log10(HD2(3,:)),'k:', 'linewidth',1); 
plot(gmID,20*log10(HD3(1,:)),'k-', 'linewidth',1); 
plot(gmID,20*log10(HD3(2,:)),'k--', 'linewidth',1); 
plot(gmID,20*log10(HD3(3,:)),'k:', 'linewidth',1); 


axis([0 30 -100 -10]); grid
xlabel('{\itg_m}/{\itI_D}  (S/A)'); 
ylabel('Harmonic distortion (dB)');
legend('{\itv_g_s_,_p_k}=10 mV', '{\itv_g_s_,_p_k}=20 mV', '{\itv_g_s_,_p_k}=30 mV', 'location', 'southeast')
text(8,-20,'HD_2', 'fontsize', 9); 
text(10,-56,'HD_3', 'fontsize', 9);

%format_and_save(h, 'Fig4_16')
