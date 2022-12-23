% 2.3.5.  real and EKV gds versus VDS for L = .06 and .20 micron
clear all
close all
addpath ../../lib
load 65nch.mat

% data ================================================
VDS = 0.1*(3:12)';
VGS = .4;
L   = [.06 .2];


% compute ==================
for k = 1:length(L),
    % look-up tables ==========================
    gds(:,k)    = lookup(nch,'GDS_W','VDS',nch.VDS,'VGS',VGS,'L',L(k));

    VDsat(1,k) = 2./lookup(nch,'GM_ID','VGS',VGS,'L',L(k));
    gdsat(1,k) = lookup(nch,'GDS_W','VDS',VDsat(1,k),'VGS',VGS,'L',L(k));

    % EKV extract param =================
    y  = XTRACT(nch,L(k),VDS,0);    
    n  = y(:,2); VTo = y(:,3); IS = y(:,4); SVT = y(:,6); SIS = y(:,7);

    % EKV drain current --------------
    UT = .026;
    VP = (VGS - VTo)./n;
    qS = invq(VP/UT);
    IDEKV = IS.*(qS.^2 + qS);
    gm    = IS./(n*UT).*qS;
    gdEKV(:,k) = - gm.*SVT + IDEKV.*SIS;  

%[-gm.*SVT  IDEKV.*SIS]
end


% plot =============
h1 = figure(1);

subaxis(1,2,1,'Spacing', 0.1, 'MarginBottom', 0.2, 'MarginTop', 0.07, 'MarginLeft', 0.1, 'MarginRight', 0.03); 

plot(nch.VDS,gds(:,1),'k',VDS, gdEKV(:,1),...
    'k+',VDsat(1),gdsat(1),'ko','linewidth', 1.01); 
axis([0 1.2 0 max(gds(:,1))]); grid
xlabel({'{\itV_D_S}  (V)'; '(a)'}); ylabel('{\itg_d_s}  (S)');

subaxis(1,2,2); plot(nch.VDS,gds(:,2),'k',VDS, gdEKV(:,2),...
    'k+',VDsat(2),gdsat(2),'ko','linewidth', 1.01); 
axis([0 1.2 0 .2*max(gds(:,2))]); grid
xlabel({'{\itV_D_S}  (V)'; '(b)'}); ylabel('{\itg_d_s}  (S)');


%format_and_save(h1, 'Fig2_22', 'W',5.3)

