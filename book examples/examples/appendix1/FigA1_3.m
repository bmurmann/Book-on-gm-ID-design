%A.1.4   linear plot of EKV/real difference ID 
clear all
close all
addpath ../../lib
load 65nch.mat

% data ============
L    = .06;
VDS  = .6;
VSB  = .0;

rho = .6;


% compute =================
y = XTRACT(nch,L,VDS,VSB,rho);
n  = y(:,2);
VT = y(:,3);
JS = y(:,4);

% verif ============
kB = 1.38e-23; 
qe = 1.602e-19; 
UT = kB*nch.TEMP/qe;
q   = logspace(-3,1,20);
i   = q.^2 + q;
VP  = UT*(2*(q-1) + log(q));
VGS = VT + n*VP;
JDEKV = i*JS;

% 'real transistor' ================
JD    = lookup(nch,'ID_W','VDS',VDS,'VSB',VSB,'L',L); 
gm_ID = lookup(nch,'GM_ID','VDS',VDS,'VSB',VSB,'L',L);
VGSo  = interp1(gm_ID*n*UT,nch.VGS,rho);
JDo   = lookup(nch,'ID_W','VGS',VGSo,'VDS',VDS,'VSB',VSB,'L',L);


% difference D =======================
m = 10:length(nch.VGS);
z = interp1(VGS,JDEKV,nch.VGS(m),'cubic')
h2 = figure(2); 
plot(nch.VGS(m),100*(1-JD(m)./z),'+-k','linewidth',1.05); grid 
xlabel('{\itV_G_S}   (V)'); ylabel('{\itD}   (%)'); 

%format_and_save(h2, 'FigA1_3')
