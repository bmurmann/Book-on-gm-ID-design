% 2.3.4   real and EKV ID versus VDS for L = .06 and .20 micron
clear all
close all
addpath ../../lib
load 65nch.mat

% data ================================================
VDS = 0.1*(2:12)';
VGS = .4;
L   = [.06 .2];


% compute ==================
for k = 1:length(L),
    % look-up tables ==========================
    ID(:,k)    = lookup(nch,'ID_W','VDS',nch.VDS,'VGS',VGS,'L',L(k));

 	gm_ID(1,k)  = lookup(nch,'GM_ID','VGS',VGS,'L',L(k));
    VDsat(1,k) = 2./gm_ID(1,k); %lookup(nch,'GM_ID','VGS',VGS,'L',L(k));
    IDsat(1,k) = lookup(nch,'ID_W','VDS',VDsat(1,k),'VGS',VGS,'L',L(k));

        
    % EKV extract param =================
    y = XTRACT(nch,L(k),VDS,0,.6);
    n  = y(:,2); VT = y(:,3); IS = y(:,4); 

    % EKV drain current --------------
    UT = .026;
    VP = (VGS - VT)./n;
    qS = invq(VP/UT);
    IDEKV(:,k) = IS.*(qS.^2 + qS);
end


% plot =============
h1 = figure(1);

subaxis(1,2,1,'Spacing', 0.1, 'MarginBottom', 0.20, 'MarginTop', 0.07, 'MarginLeft', 0.1, 'MarginRight', 0.03); 

plot(nch.VDS,ID(:,1),'k',VDS, IDEKV(:,1),...
    'k+',VDsat(1),IDsat(1),'ko','linewidth', 1.01); 
axis([0 1.2 0 max(ID(:,1))]); grid
xlabel({'{\itV_D_S}  (V)'; '(a)'}); ylabel('{\itI_D}  (A)');

subaxis(1,2,2); 
plot(nch.VDS,ID(:,2),'k',VDS, IDEKV(:,2),...
    'k+',VDsat(2),IDsat(2),'ko','linewidth', 1.01); 
axis([0 1.2 0 max(ID(:,2))]); grid
xlabel({'{\itV_D_S}  (V)'; '(b)'}); ylabel('{\itI_D}  (A)');


%format_and_save(h1, 'Fig2_20','W',5.3)

