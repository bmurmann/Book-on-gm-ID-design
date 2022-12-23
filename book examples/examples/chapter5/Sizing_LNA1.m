% 5.4   LNA sizing procedure
clearvars;
close all
addpath ../../lib
load 65nch.mat

% data
L    = .08;
VR1  = .3;
VGS1 = .600;
gm_ID2 = (7:1:13)';
m      = (5:11); 
RS = 50;
VDD = 1.2;


% CS stage ====================
z2 = length(gm_ID2);

% 1) VDS2 for min HD2 (cf Fig 4.28)==========
Vds = .2: .02: .64;
for k = 1:z2,
    UGS = lookupVGS(nch,'GM_ID',gm_ID2(k),'VDS',Vds,'L',L); 
    y   = blkm(nch,L,Vds,UGS);
    A1  = (y(:,:,6) - sqrt(y(:,:,6).^2 - y(:,:,4).*y(:,:,5)))./y(:,:,5); 
    U   = diag(y(:,:,3)./(y(:,:,1)./A1 - y(:,:,2)));
    z(k,:) = interp1(VDD-Vds'-U,[UGS  (VDD-U)  diag(A1)],0);
end

A2   = z(:,3);
VDS2 = z(:,2);
VGS2 = z(:,1);
VR2  = VDD - VDS2;
JD2     = diag(lookup(nch,'ID_W','GM_ID',gm_ID2,'VDS',VDS2,'L',L));
gds_ID2 = diag(lookup(nch,'GDS_ID','GM_ID',gm_ID2,'VDS',VDS2,'L',L));
Cgg_W2  = diag(lookup(nch,'CGG_W','GM_ID',gm_ID2,'VDS',VDS2,'L',L));
fT2     = diag(lookup(nch,'GM_CSS','GM_ID',gm_ID2,'VDS',VDS2,'L',L))/(2*pi);

ID1 = 1/RS*1./(1./VGS2 + A2/VR1);   % matching
R1 = VR1./ID1;
RB = VGS2./ID1;
VDS1 = VDD - VR1 - VGS2;
JD1 = diag(lookup(nch,'ID_W','VGS',VGS1,'VDS',VDS1,'VSB',VGS2,'L',L));
W1  = ID1./JD1;

gm_ID1  = diag(lookup(nch,'GM_ID','VGS',VGS1,'VDS',VDS1,'VSB',VGS2,'L',L));
gmb_ID1 = diag(lookup(nch,'GMB_ID','VGS',VGS1,'VDS',VDS1,'VSB',VGS2,'L',L));
gds_ID1 = diag(lookup(nch,'GDS_ID','VGS',VGS1,'VDS',VDS1,'VSB',VGS2,'L',L));
Css_W1  = diag(lookup(nch,'CSS_W','VGS',VGS1,'VDS',VDS1,'VSB',VGS2,'L',L));
fT1     = diag(lookup(nch,'GM_CSS','VGS',VGS1,'VDS',VDS1,'VSB',VGS2,'L',L))/(2*pi);


gms_ID1 = gm_ID1 + gmb_ID1;
A1 = (gms_ID1 + gds_ID1)./(gds_ID1 + 1/VR1);
y = interp1(A2./A1,[A2 gm_ID1 gm_ID2 VGS2 ID1 W1 R1 RB JD2 VR2 Css_W1 Cgg_W2 VDS2 fT1 fT2],1);


W1 = y(6)
R1 = y(7)
RB = y(8)
VB = y(13)

gmID1 = y(2)
gmID2 = y(3)

ID1 = y(5)

VGS1
VGS2  = y(4)
VGB1 = VGS1 + VGS2

Av = 2*y(1)
fT1 = y(14)
fT2 = y(15)

Css_W = y(11);
Cgg_W = y(12);


% Noise Figure ========================
z1 = length(m);  
kB = 1.3806488e-23;
gam = lookup(nch, 'STH_GM', 'VGS', VGS2, 'L',L)/4/kB/nch.TEMP;
    
   
gm1 = gmID1.*ID1;
for k = 1:z1,
    ID2(:,k) = ID1*m(k);
    R2(:,k) = VR2./ID2(:,k);
    gm2  = gm_ID2.*ID2(:,k);
    gds2 = gds_ID2.*ID2(:,k);

    Denom = .25*RS * Av.^2; 
    F1 = gam.*gm1.*(R1 - Av*RS/2).^2./Denom;
    F2 = gam.*gm2.*(R2(:,k)./(1+R2(:,k).*gds2)).^2./Denom;
    F3 = (R1 + R2(:,k))./Denom;
    F4 = RS./RB;        
    F  = 1 + F1 + F2 + F3 + F4;
    NF(:,k) = 10*log10(F);   % vert gm_ID2,  horiz ID2/ID1
    
end


ID2
W2 = ID2/y(9)
R2 = y(10)./ID2
noise_figure = diag(NF)'      

Css1 = Css_W.*W1;
C_in = Css1 + W2*Cgg_W;
fc_in_GHz = 1e-9./(2*pi*RS*C_in)











