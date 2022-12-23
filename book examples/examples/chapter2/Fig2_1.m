% 2.1.1   CSM drift and diff currents
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

% pMat computes [phiB; Gamma; UT; K; Cox] ============
% versus
% 	T absolute temperature				°K   
%	N substrate (uniform) doping		cm^-3
%		N > 0  for P-type substrate
%		N < 0  for N-type substrate
% 	tox  oxide thickness   				nm
% NOTE: T, N and tox may be scalars or equal length row vectors 
p  = pMat(T,N,tox);
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
ID = IDdrift+IDdiff;

% plot ----------------------------------------
h = figure(1);
%semilogy(VG,IDdrift,'k',VG,IDdiff,'k',VG,IDsh(p,VS,VD,VG+VFB),'k--','linewidth',1); 
semilogy(VG,IDdrift,'k',VG,IDdiff,'k',VG,ID,'k--','linewidth',1); 

axis([0 2 1e-15 1e-3]); grid
xlabel('{\itV_G_S}     (V)')
ylabel('{\itI_D}     (A)')
text(.38,1e-13,'Drift current')
text(1,1e-6,'Diffusion current')
set(gca, 'ytick', 10.^(-14: 2: -4));

%format_and_save(h, 'Fig2_01')