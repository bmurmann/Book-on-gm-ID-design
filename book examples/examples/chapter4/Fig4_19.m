% HD3 of diffpair
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% data ==============
L = .1;
VDB = 1.2;
VGB = 1.2;
VS  = (VGB-.2: -.05: 0)'; zs = length(VS);

% compute =======
UT  = 0.026;
VGS = VGB - VS;
VDS = VDB - VS;
gm_ID = lookup(nch,'GM_ID','VGS',VGS,'VSB',VS,'VDS',VDS,'L',L*ones(zs,1));

vin = .01;
n = [1 1.5];
for k = 1:length(n)
    q = 1./(n(k)*UT*gm_ID) - 1
    HD3(:,k) = 1/24*((1+q).^2.*(1+3*q))./(2*(1+2*q).^3).*gm_ID.^2*vin^2;  
end


% Spice data
load('Fig4_19.mat')
hd3 = vo(4,:)./vo(2,:);
hd3_db = 20*log10(hd3);

% Square-law expression
hd3_sq = 1/32*(vin./(vgs-vth)).^2;
idx = find(vgs-vth<=0);
hd3_sq(idx) = NaN;

% BJT expression
hd3_bjt = 1/48*(vin./UT).^2;

% plot
h = figure(1);
subaxis(1,2,1,'Spacing', 0.07, 'MarginBottom', 0.20, 'MarginTop', 0.05, 'MarginLeft', 0.12, 'MarginRight', 0.03); 
plot(gm_ID,20*log10(HD3(:,1)),'k-'); 
hold
plot(gm_ID,20*log10(HD3(:,2)),'k--'); 
plot(gm./id, hd3_db, 'k', 'linewidth', 2)
xlabel({'{\itg_m}/{\itI_D}   (S/A)';'(a)'}); 
ylabel('HD_3  (dB)');
axis([0 30 -120 -48]); grid;
g = legend('(4.31) {\itn} = 1.0', '(4.31) {\itn} = 1.5', 'SPICE', 'location', 'southeast');
set(g, 'fontsize', 9);

subaxis(1,2,2); 
plot(vgs,20*log10(hd3_sq),'k:','color', 0.7*[1 1 1], 'linewidth', 2);
hold on;
plot([0 1.3],[1 1]*20*log10(hd3_bjt),'color', 0.7*[1 1 1], 'linewidth', 2);
plot(vgs, hd3_db, 'k', 'linewidth', 2);
plot(VGS,20*log10(HD3(:,1)),'k');
plot(VGS,20*log10(HD3(:,2)),'k--');
axis([0.3 1.3 -120 -48]); grid; 
xlabel({'{\itV_G_S}  (V)';'(b)'});
g = legend('Square-law', 'BJT', 'location', 'southwest');
set(g, 'fontsize', 9);

%format_and_save(h, 'Fig4_19', 'W', 5.3, 'H', 3)

