% 4.2.3   VDS and Av nulling HD2,  given L 
clear all
close all
addpath ../../lib
load 65nch.mat

% data ==================
VDD = 1.2;   
L   = .06;
UDS = .2: .02: .64;
gm_ID = (5:20);

% compute ===============
for k = 1:length(gm_ID),
    UGS = lookupVGS(nch,'GM_ID',gm_ID(k),'VDS',UDS,'L',L); 
    y   = blkm(nch,L,UDS,UGS);
    gm1 = y(:,:,1);
    gd1 = y(:,:,2);
    jd1 = y(:,:,3);
    gm2 = y(:,:,4);
    gd2 = y(:,:,5);
    x11 = y(:,:,6);
    A1  = (x11 - sqrt(x11.^2 - gm2.*gd2))./gd2; 
    UR  = diag(jd1./(gm1./A1 - gd1));
    z(k,:) = interp1(VDD-UDS'-UR,[UGS  (VDD-UR)  diag(A1)  diag(y(:,:,1))],0);
end
VDS = z(:,2);
VGS = z(:,1);
Av0 = z(:,3);

% plot =====================
h = figure(1);
plot(gm_ID,z(:,2),'k',gm_ID,.1*Av0,'k--','linewidth',1) ; grid; 
axis([min(gm_ID) max(gm_ID) 0 .8])
xlabel('{\itg_m}/{\itI_D}    (S/A)');
text(7,.22,'|{\ita_1}| / 10'); 
text(7,.57,'{\itV_D_S} (V)');

%format_and_save(h, 'Fig4_29')


% size ID and W ===================
fu = 1e9;
CL = 1e-12;

gm1 = 2*pi*fu*CL;
ID  = gm1./gm_ID';
W   = gm1./z(:,4); 
R   = (VDD-VDS)./ID;

[gm_ID' VGS VDS Av0 1e3*ID W 1e-3*R]


