% 5.1   nonlinearity of current mirror
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat 

% data ===================
VDD = 1.2;
V   = .1; 
R   = 2000;
Ln  = .2;
Lp  = .5;
gm_ID2 = 12;     
gm_ID3 = 8;


% 1) compute node voltages =========
VGS2o = lookupVGS(nch,'GM_ID',gm_ID2,'L',Ln);
VGS2o = lookupVGS(nch,'GM_ID',gm_ID2,'VDS',VGS2o,'L',Ln);

VGS3o = lookupVGS(pch,'GM_ID',gm_ID3,'L',Lp);
VGS3o = lookupVGS(pch,'GM_ID',gm_ID3,'VDS',VGS3o,'L',Lp);

VDS4o = VDD - VGS2o;
VDS1o = VDD - VGS3o - V;

IDo = V/R   

% 2) size (same currents in the two branches = distinct W3 and W4) ======
JD3o = lookup(pch,'ID_W','VGS',VGS3o,'VDS',VGS3o,'L',Lp);
W3   = IDo/JD3o;

JD4o = lookup(pch,'ID_W','VGS',VGS3o,'VDS',VDS4o,'L',Lp); 
ID4  = W3*JD4o;

JD2o = lookup(nch,'ID_W','VGS',VGS2o,'VDS',VGS2o,'L',Ln);
W2   = ID4/JD2o;

JD1o = lookup(nch,'ID_W','VGS',VGS2o-V,'VDS',VDS1o,'VSB',V,'L',Ln);
W1   = IDo/JD1o;

widths = [W1 W2 W3]
VDS = [VDS4o VDS1o]
gm3 = gm_ID3*IDo


% 2) ID1(ID2)  characteristic ===================
VS = V + 1e-2*(-9:1)';
ID1  = VS/R;

VDS1 = VDD - VGS3o - VS;
UGS  = VGS2o-.3: .01: VGS2o+0.1;
for k = 1:length(VS),
    Id1 = W1*lookup(nch,'ID_W','VGS',UGS,'VDS',VDS1(k),'VSB',VS(k),'L',Ln);
    VG1(k,1) = interp1((Id1/ID1(k)),UGS,1) ;
end
VG2 = VG1 + VS;  
ID2 = W2*diag(lookup(nch,'ID_W','VDS',VG2,'VGS',VG2,'L',Ln));
% [UGS' Id1*1e6]
gm2 = W2.*lookup(nch,'GM_W','VGS',VGS2o,'VDS',VGS2o,'L',Ln);
gm2.*R

% 3) plot =================
h = figure(1);
K = JD3o/JD4o;  % = ID3/ID4 = ID0/ID2;
K = 1;
plot(ID2*K,ID1,'k-+',ID2,ID2,'k--',IDo,IDo,'ko','linewidth',1.1); grid
axis([0 6e-5 0 6e-5]); 
xlabel('{\itI_D_2}  (A)'); ylabel('{\itI_D_1}  (A)');

%format_and_save(h, 'Fig5_2') 


















