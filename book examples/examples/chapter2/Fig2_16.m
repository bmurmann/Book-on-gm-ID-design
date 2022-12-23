% 2.3.2   VDsat
clear all;
close all;
addpath ../../lib
load 65nch.mat;

% data ------------
L = .1;
VGS = (.3: .1: 1)';
VDS = (.001: .015: 1.2)';

% VDsat and IDsat (lookup funct)-------------------
gm_ID = lookup(nch,'GM_ID','VGS',VGS,'L',L);
VDsat = 2./gm_ID;
JDsat = diag(lookup(nch,'ID_W','VDS',VDsat,'VGS',VGS,'L',L));

% EKV model -------------------------
UT = .026;
y = XTRACT(nch,L,VDsat,0)
VP = (VGS - y(:,3))./y(:,2)
qs = invq(VP/UT)
vdsat = 2*UT*y(:,2).*(1 + qs)
idsat = y(:,4).*(qs.^2 + qs)


% plot ------------------------------
N = length(VDS);
JD = lookup(nch,'ID_W','VDS',VDS,'VGS',VGS,'L',L);
N1 = 55; VDS1 = VDS(1:N1); JD1 = JD(:,1:N1);
N2 = 73; VDS2 = VDS(N2:N); JD2 = JD(:,N2:N);

h = figure(1);
semilogy(VDS1,JD1,'k',VDS2,JD2','k',VDsat,JDsat,'k',vdsat,idsat,'*k', 'linewidth', 1.01)
axis([0 1.2 1e-9 1e-3])
xlabel('{\itV_D_S}  (V)'); ylabel('{\itJ_D}  (A)');
text(.88,JD(1,62),'0.3', 'fontsize', 9)
text(.88,JD(2,62),'0.4', 'fontsize', 9)
text(.88,JD(3,62),'0.5', 'fontsize', 9)
text(.88,JD(4,62),'0.6', 'fontsize', 9)
text(.88,JD(8,62),'1.0', 'fontsize', 9)
text(.88,1e-8,'{\itV_G_S} (V)', 'fontsize', 9)

%format_and_save(h, 'Fig2_16')
