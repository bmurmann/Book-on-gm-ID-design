% 2.3.4   real and EKV ID versus VDS for VGS = 0.4 and .8 V (L = 0.06)
clear all
close all
addpath ../../lib
load 65nch.mat

% data =================
L   = .06;
VDS = .1*(4:12)';
VGS = [.3 .8];

% compute =============
kB = 1.38e-23; qe = 1.602e-19; UT = kB*nch.TEMP/qe;
for k = 1:2
UGS = VGS(1,k);
    gmID = lookup(nch,'GM_ID','VGS',UGS,'L',L)
    y = XTRACT(nch,L,VDS,0,.6);
    n   = y(:,2); 
    VTo = y(:,3); 
    IS  = y(:,4); is(:,k) = IS;
    VP  = (UGS - VTo)./n;
      % the invq function extract qS from VP/UT inverting Eq. (2.22).
    qS  = invq(VP/UT);
    IDEKV(:,k) = IS.*(qS.^2 + qS);
    JD(:,k) = lookup(nch,'ID_W','VDS',nch.VDS,'VGS',UGS,'L',L);
    VDsat(1,k) = 2./lookup(nch,'GM_ID','VGS',UGS,'L',L);
    IDsat(1,k) = lookup(nch,'ID_W','VDS',VDsat(1,k),'VGS',UGS,'L',L);
end


% plot =================
h = figure(1);
subaxis(1,2,1,'Spacing', 0.1, 'MarginBottom', 0.2, 'MarginTop', 0.08, 'MarginLeft', 0.1, 'MarginRight', 0.03); 
plot(VDS,IDEKV(:,1),'k+',nch.VDS,JD(:,1),'k',...
    VDsat(1,1),IDsat(1,1),'ok','linewidth',1.01)
xlabel({'{\itV_D_S}  (V)'; '(a)'}); ylabel('{\itI_D}  (A)'); 
axis([0 1.2 0 max(JD(:,1))]); grid
subaxis(1,2,2), plot(VDS,IDEKV(:,2),'k+',nch.VDS,JD(:,2),'k',...
    VDsat(1,2),IDsat(1,2),'ok','linewidth',1.01)
xlabel({'{\itV_D_S}  (V)'; '(b)'}); 
ylabel('{\itI_D}  (A)'); 
axis([0 1.2 0 max(JD(:,2))]); grid


%format_and_save(h, 'Fig2_21','W',5.3)
