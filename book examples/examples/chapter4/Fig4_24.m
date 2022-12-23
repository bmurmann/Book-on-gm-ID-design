% 4.2.3   2d derivatives < - > EKV approx versus gm/ID
clear all
close all
addpath ../../lib
load 65nch.mat;

% data ==============
L   = .1;
UDS = .6;
USB = 0;

% 1) compute 'real' derivatives ============= 
dvg   = .025;     VGS = (.3: dvg: 1.2)';      
dvd   = .050;     VDS = .3: dvd: 1.2;
[X Y] = meshgrid(VDS,VGS);
         
VGS1  = .5*(VGS(1:end-1)+VGS(2:end));
VDS1  = .5*(VDS(1:end-1)+VDS(2:end));

JD  = lookup(nch,'ID_W','VGS',VGS,'VDS',VDS,'L',L);
 
GM1 = diff(JD)./diff(Y);
gm1 = interp1(VGS1,GM1,VGS,'spline'); % matrix like ID.
 
GM2 = diff(gm1)./diff(Y);
gm2 = interp1(VGS1,GM2,VGS,'spline');
 
GD1 = (diff(JD')./diff(X'));
gd1 = interp1(VDS1,GD1,VDS,'spline')';
 
GD2 = (diff(gd1')./diff(X'));
gd2 = interp1(VDS1,GD2,VDS,'spline')';
 
X11 = diff(gd1)./diff(Y);
x11 = interp1(VGS1,X11,VGS,'spline');

gm_ID = gm1./JD;

% 2) EKV dervatuves ==================
UT   = .026;
y    = XTRACT(nch,L,UDS,USB,.8);    % W = 1 µm
% y = [VDS n VT JS d1n d1VT d1logJS d2n d2VT d2logJS];

n    = y(2);
VTo  = y(3);
JS   = y(4);
SVT  = y(6); 
SIS  = y(7); 
dSVT = y(9); 
dSIS = y(10);

q  = logspace(-2,1,20);
VP = UT*(2*(q-1) + log(q));
VG = n*VP + VTo;
JD = JS*(q.^2 + q);
gmID = 1./(n*UT*(1+q))

gM1  = q*JS./(n*UT);                                % see equ (4.21)
gM2  = JS/(n*UT)^2*q./(2*q+1);                      % see equ (4.21)
gDS1 = - gM1*SVT + JD*SIS;                          % see equ (2.42)
X11  = gM1*SIS - gM2*SVT;                           % see equ (4.36)
gDS2 = gDS1*SIS - X11*SVT + JD*dSIS - gM1*dSVT;     % see equ (4.37)



% plot ============================
uds = [1 7 13]; % select VDS = .3, .6 and .9 V.

h1 = figure(1)
subaxis(3,2,1,'Spacing', 0.10, 'MarginBottom', 0.09, 'MarginTop', 0.04, 'MarginLeft', 0.09, 'MarginRight', 0.02); 
plot(gm_ID(:,uds(1)),gm2(:,uds(1)),'k:','linewidth',1);
hold on;
plot(gm_ID(:,uds(2)),gm2(:,uds(2)),'k','linewidth',1);
plot(gm_ID(:,uds(3)),gm2(:,uds(3)),'k-.','linewidth',1);
xlabel({'{\itg_m}/{\itI_D}   (S/A)';'(a)'},'fontsize',9)
ylabel('{\itg_m_2}  (S/V)'); 
axis([0 30 -1e-3 2e-3]); grid

subaxis(3,2,3); 
plot(gm_ID(:,uds(1)),gd2(:,uds(1)),'k:','linewidth',1); 
hold on;
plot(gm_ID(:,uds(2)),gd2(:,uds(2)),'k','linewidth',1); 
plot(gm_ID(:,uds(3)),gd2(:,uds(3)),'k-.','linewidth',1); 
xlabel({'{\itg_m}/{\itI_D}  (S/A)';'(c)'},'fontsize',9)
ylabel('{\itg_d_s_2}  (S/V)'); 
axis([0 30 -15e-4 5e-4]); grid
g1 = legend('{\itV_D_S}=0.3 V', '{\itV_D_S}=0.6 V', '{\itV_D_S}=0.9 V', 'location', 'southeast');
set(g1, 'fontsize', 9);

subaxis(3,2,5); 
plot(gm_ID(:,uds(1)),x11(:,uds(1)),'k:','linewidth',1);
hold on;
plot(gm_ID(:,uds(2)),x11(:,uds(2)),'k','linewidth',1);
plot(gm_ID(:,uds(3)),x11(:,uds(3)),'k-.','linewidth',1);
xlabel({'{\itg_m}/{\itI_D}  (S/A)';'(e)'},'fontsize',9)
ylabel('{\itx_1_1}  (S/V)'); 
axis([0 30 0 1e-3]); grid

subaxis(3,2,2); plot(gmID,gM2,'k--',gm_ID(:,7),gm2(:,7),'k','linewidth',1); 
xlabel({'{\itg_m}/{\itI_D}   (S/A)';'(b)'},'fontsize',9)
ylabel('{\itg_m_2}  (S/V)'); 
axis([-2 30 -1e-3 2e-3]); grid
g = legend('EKV', 'Real', 'location', 'southeast');
set(g, 'fontsize', 9);

subaxis(3,2,4); plot(gmID,gDS2,'k--',gm_ID(:,7),gd2(:,7),'k','linewidth',1); 
xlabel({'{\itg_m}/{\itI_D}   (S/A)';'(d)'},'fontsize',9)
ylabel('{\itg_d_s_2}  (S/V)'); 
axis([0 30 -15e-4 5e-4]); grid
g = legend('EKV', 'Real', 'location', 'southeast');
set(g, 'fontsize', 9);

subaxis(3,2,6); plot(gmID,X11,'k--',gm_ID(:,7),x11(:,7),'k','linewidth',1); 
xlabel({'{\itg_m}/{\itI_D}   (S/A)';'(f)'},'fontsize',9)
ylabel('{\itx_1_1}  (S/V)'); 
axis([0 30 0 1e-3]); grid
g = legend('EKV', 'Real', 'location', 'northeast');
set(g, 'fontsize', 9);

%format_and_save(h1, 'Fig4_24', 'W', 5.3, 'H', 6.6)
 





