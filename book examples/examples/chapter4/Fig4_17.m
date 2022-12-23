% Fig. 4.17   fractional 2d and 3d harminic distortion comparison EKV model
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% data ==========================
L   = 0.1;
VGS = nch.VGS;
VDS = 0.6;

% compute ================
id = lookup(nch,'ID','VDS',VDS,'L',L);

% EKV ---------------
UT = .026;
y   = XTRACT(nch,L,VDS,0);  % extracts EKV para n, VTo and IS

n   = y(2);

q      = logspace(-2,1,50);
gmID   = 1./(n*UT*(1+q));

v = .01*(1:3); 
for k = 1:length(v),
    u = v(k);
    HD2(k,:) = 1/4*gmID.*(1 + q)./(1 + 2*q).*u;         
    HD3(k,:) = 1/24*gmID.^2.*(1 + q).^2./(1 + 2*q).^3.*u.^2;
end

% Spice data
load('Fig4_17.mat')
hd2 = vo(3,:)./vo(2,:);
hd2_db = 20*log10(hd2);
hd3 = vo(4,:)./vo(2,:);
hd3_db = 20*log10(hd3);

% plot
h = figure(1);
plot(gmID,20*log10(HD2(1,:)),'k--',gmID,20*log10(HD3(1,:)),'k--','linewidth',1); 
hold on;
plot(gm_id, hd2_db, 'k', gm_id, hd3_db, 'k', 'linewidth',1);
grid;
text(23, -34, 'HD_2', 'fontsize', 9);
text(23, -68, 'HD_3', 'fontsize', 9);
axis([3 30 -110 -20]);
xlabel('{\itg_m}/{\itI_D}  (S/A)'); 
ylabel('Harmonic distortion (dB)');

%format_and_save(h, 'Fig4_17');
