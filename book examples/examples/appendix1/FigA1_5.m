%A.1.4   replica of fig 4.2 when rho = 0.2 (strong inversion)
clear all
close all
addpath ../../lib
load 65nch.mat

kB = 1.38e-23; 
qe = 1.602e-19; 
UT = kB*nch.TEMP/qe;

% data ============
L    = .06;
VDS  = .6;
VSB  = .0;
rho  = 0.2;

% compute =================
y = XTRACT(nch,L,VDS,VSB,rho);
n  = y(:,2);
VT = y(:,3);
JS = y(:,4);

% verif ============
q   = logspace(-3,1,20);
i   = q.^2 + q;
VP  = UT*(2*(q-1) + log(q));
VGS = VT + n*VP;
JDEKV = i*JS;

% 'real transistor' ================
JD    = lookup(nch,'ID_W','VDS',VDS,'VSB',VSB,'L',L); 
gm_ID = lookup(nch,'GM_ID','VDS',VDS,'VSB',VSB,'L',L);
M = max(gm_ID);
gmIDo = rho*M;
VGSo  = interp1(gm_ID,nch.VGS,gmIDo);
JDo   = lookup(nch,'ID_W','VGS',VGSo,'VDS',VDS,'VSB',VSB,'L',L);


% plot ==============
h1 = figure(1);
subaxis(2,1,1,'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.02, 'MarginLeft', 0.15, 'MarginRight', 0.03) 
semilogy(VGS,JDEKV,'k-+',nch.VGS,JD,'k',...
    VGSo,JDo,'ok','linewidth',1.05); 
xlabel({'{\itV_G_S}  (V)'; '(a)'}); 
ylabel('{\itJ_D}  (A)'); grid;
g = legend('Basic EKV', 'Lookup data', 'location', 'southeast');
set(g, 'fontsize', 9)

subaxis(2,1,2); plot(VGS,1./(n.*(1+q)*UT),'k-+',nch.VGS,gm_ID,'k',...
    VGSo,gmIDo,'ok','linewidth',1.05); 
xlabel({'{\itV_G_S}  (V)'; '(b)'}); 
ylabel('{\itg_m}/{\itI_D}  (S/A)'); grid

%format_and_save(h1, 'FigA1_5', 'H', 5.5)(h1, 'FigA1_5', 'H', 5.5)

