% 5.3   LDO sizing procedure   
clearvars;
close all;
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat  

% data =======================
VDD = 1.2;         % supply voltage     
V   = .9;          % desired regulated voltage
ID  = .01;         % desired current (Y = 1D/V)
L = 0.1;
Lp = .5;
Ln = .5;
gm_ID  = 10;
gm_IDN = 20;

% series transistor =================
VDS = VDD - V;
JD  = lookup(pch,'ID_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
gds_ID = lookup(pch,'GDS_ID','GM_ID',gm_ID,'VDS',VDS,'L',L);
A = gm_ID./(1/V + gds_ID)

W   = ID./JD
Cgs = W*lookup(pch,'CGS_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
Cgd = W*lookup(pch,'CGD_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
VGS = lookupVGS(pch,'GM_ID',gm_ID,'VDS',VDS,'L',L)
gm = gm_ID*ID
gds = gds_ID*ID
Y = ID/V


% current mirror =================
gds_IDp = lookup(pch,'GDS_ID','VGS',VGS,'VDS',VGS,'L',Lp);


% diff pair (horizontal) ======================
VD  = VDD - VGS; 
US = (.2: .02: .5)'; zn = length(US);
for k = 1:zn
   	VS = US(k);
   	gm_IDn(k,1)  = lookup(nch,'GM_ID','VGS',V-VS,'VDS',VD-VS,'VSB',VS,'L',Ln);
 	gds_IDn(k,1) = lookup(nch,'GDS_ID','VGS',V-VS,'VDS',VD-VS,'VSB',VS,'L',Ln);
end
Aa = gm_IDn./(gds_IDn + gds_IDp); 
gain = Aa.*A;


% find diff pair data matching the desired (gm/ID)N ==============
yo = interp1(gm_IDn,[US Aa gds_IDn],gm_IDN);
VS = yo(1)
Aa = yo(2)
gds_IDn = yo(3)

% fix  IDn =============
IDn = 10e-5;
JDn = lookup(nch,'ID_W','VGS',V-VS,'VDS',VD-VS,'VSB',VS,'L',Ln);
Wn  = IDn/JDn
JDp = lookup(pch,'ID_W','VGS',VGS,'VDS',VGS,'L',Lp);
Wp  = IDn/JDp

gda = (gds_IDp + gds_IDn)*IDn
gma = gm_IDN*IDn


% 3) zero ==================
    z  = - gda/(Cgs + Cgd*(1+gm/gds))
    
% 4) optimal output cap (pole-zero cancellation) ================
    
    M = (Y+gds)*(Cgs+Cgd) + Cgd*(gm+gda-gma);
    N = (Y+gds)*gda + gm*gma;
    a = gda^2;
    b = 2*gda*M - 4*(Cgs+Cgd)*N;
    c = M^2 - 4*Cgs*Cgd*N;
    C1 = (- b + sqrt(b^2 - 4*a*c))/(2*a)
    
    zC2 = 500
    C2  = C1*(1+(0:zC2)/zC2)';
    D2 = C2*(Cgd+Cgs) + Cgs*Cgd;
    D1 = C2*gda + (Cgs+Cgd)*(Y+gds) + Cgd*(gda+gm-gma);
    D0 = gm*gma + (Y+gds)*gda;
    P = [D2 D1 D0*ones(zC2+1,1)];
   
    T = D2*z^2 + D1*z + D0;
    Co = interp1(T,C2,0)
    % 5) PSR cut-off frequency (the other pole) =============

    fc = ((Y+gds) + gm*gma/gda)*(Cgs + Cgd*(1+gm/gds))...
        /(Co*(Cgs+Cgd) + Cgs*Cgd)/(2*pi)

% data for Fig. 5.15 and subsequent ones;
save Fig5_15.mat gm_ID gm_IDn L Lp Ln ID VDD V Y W A Aa ...
        Wn Wp gm gma gds gda Cgs Cgd z Co fc


