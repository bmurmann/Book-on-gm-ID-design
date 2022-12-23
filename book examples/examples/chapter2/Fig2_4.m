% 2.1.2   CSM gm/ID
clear all
close all
addpath ../../lib

% data techno --------------------------
T   = 300;                    	% temperature °K
N   = 1e17;                    	% doping conc. cm^-3
tox = 5;                        % oxide thickness nm
VFB = .6;                       % flat-band voltage V
VS  = 0;                       	% source voltage V
VG  = linspace(0.0,2,50).';  	% gate voltage V
VD  = 3;                     	% drain voltage V
% all voltages are expressed with respect to the substrate

% compute pMat (see annex A2.1.1) --------------------- 
p = pMat(T,N,tox);
UT = p(3,1); gam = p(2,1); K = p(4,1);

% compute -------------------------------
UG = VG + VFB;
VS = VS*ones(length(VG),1);
VD = VD*ones(length(VG),1);
psiS = surfpot(p,VS,UG);    %(equ. A2.1.2)
psiD = surfpot(p,VD,UG);
A1 = [-.5 -2/3*gam 0 0 0];  %(annex A2.1.3, equ. 2.22 and 2.23)
IDdrift = K*(polyval(A1,sqrt(psiD)) - polyval(A1,sqrt(psiS)) + UG.*(psiD- psiS));
A2 = [UT gam*UT 0];
IDdiff = K*(polyval(A2,sqrt(psiD)) - polyval(A2,sqrt(psiS))); 
ID = IDdrift + IDdiff;

gm_ID1 = diff(log(ID))./diff(VG);
UG = .5*(VG(1:49) + VG(2:50));
gm_ID = interp1(UG,gm_ID1,VG,'pchip');

% plot ----------------
h = figure(1);
plot(VG,gm_ID,'k-', 'linewidth', 1); grid; axis([0 2 0 35]);
xlabel('{\itV_G_S}  (V)'); ylabel('{\itg_m/I_D}  (S/A)');

%format_and_save(h, 'Fig2_04')

