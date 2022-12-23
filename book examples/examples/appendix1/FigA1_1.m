%A.1.2   data for EKV param acquisition 
close all
addpath ../../lib
load 65nch.mat

% data ============
L    = .06;
VDS  = .6;
VSB  = .0;

gmID = 15;

% compute ==============
gm_ID = lookup(nch,'GM_ID','VDS',VDS,'VSB',VSB,'L',L);
VGSo  = interp1(gm_ID,nch.VGS,gmID);

[a b] = max(gm_ID)

% plot ====================
h = figure(1);
plot(nch.VGS,gm_ID,'k','linewidth',1); grid; 
hold;
plot(VGSo,gmID,'ok',[0 .3],a*[1 1],'k--',VGSo*[1 1],[3 gmID],'k--',VGSo*[1 1],[0 1],'k--',...
    nch.VGS(b),a,'ko',...
    [0 .05],gmID*[1 1],'k--',[.3 VGSo],gmID*[1 1],'k--','linewidth',1)
text(.415,2.5,'{\itV_G_S_o} \rightarrow {\itI_D_o}')
text(.1,14.7,'({\itg_m}/{\itI_D})_{\ito}')
text(.91*nch.VGS(b),1.06*a,'\itM')
xlabel('{\itV_G_S}  (V)'); ylabel('{\itg_m}/{\itI_D}  (S/A)');
axis([0 1.2 0 30]);
hold

% format_and_save(h, 'FigA1_1')




