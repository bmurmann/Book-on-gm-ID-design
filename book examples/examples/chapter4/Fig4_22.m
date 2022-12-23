% 4.2.3   1st derivatives < - > EKV approx versus VGS
clear all
close all
addpath ../../lib
load 65nch.mat;

% data =============
L = .1;
UDS = .6;
USB = 0;

% Blaakmeer derivatives ===========
dvg   = .025;     VGS = (.2: dvg: 1.2)'; 
dvd   = .050;     VDS = (.3: dvd: 1.2);      

y = blkm(nch,L,VDS,VGS);
gm1 = y(:,:,1); 
gd1 = y(:,:,2); 
JD  = y(:,:,3); 
gm2 = y(:,:,4); 
gd2 = y(:,:,5); 
x11 = y(:,:,6); 


% EKV derivatives ==================
UT   = .026;
y    = XTRACT(nch,L,UDS,USB,.8);
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
h1  = figure(1);
uds = [1 7 13]; % select VDS = .3, .6 and .9 V.
zG  = length(VGS);

subaxis(2,2,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.04, 'MarginLeft', 0.1, 'MarginRight', 0.03)
plot(VGS,gm1(:,uds(1)),'k:','linewidth',1); 
hold on;
plot(VGS,gm1(:,uds(2)),'k-','linewidth',1); 
plot(VGS,gm1(:,uds(3)),'k-.','linewidth',1); 
text(1.05,.85*gm1(zG,1),'0.3 V', 'fontsize', 9); 
text(1.05,.9*gm1(zG,7),'0.6 V', 'fontsize', 9); 
text(0.82,1.15*gm1(zG,13),'{\itV_D_S} = 0.9 V', 'fontsize', 9);
xlabel({'{\itV_G_S}  (V)'; '(a)'})
ylabel('{\itg_m_1}  (S)'); 
axis([0 1.3 0 1e-3]); 
grid;

subaxis(2,2,3); 
plot(VGS,gd1(:,uds(1)),'k:','linewidth',1);
hold on;
plot(VGS,gd1(:,uds(2)),'k-','linewidth',1);
plot(VGS,gd1(:,uds(3)),'k-.','linewidth',1);
xlabel({'{\itV_G_S}  (V)'; '(c)'},'fontsize',9)
ylabel('{\itg_d_s_1} (S)'); 
axis([0 1.3 0 1e-3]); 
grid;

subaxis(2,2,2); 
plot(VG,gM1,'k--',VGS,gm1(:,7),'k','linewidth',1); 
axis([0 1.3 0 1e-3]); 
xlabel({'{\itV_G_S}  (V)';'(b)'});
ylabel('{\itg_m_1}  (S)'); 
grid;
g = legend('EKV', 'Real', 'location', 'northwest');
set(g, 'fontsize', 9);
text(1.05,.9*gm1(zG,7),'0.6 V', 'fontsize', 9); 

subaxis(2,2,4); plot(VG,gDS1,'k--',VGS,gd1(:,7),'k','linewidth',1);   
axis([0 1.3 0 1e-3]); 
xlabel({'{\itV_G_S}  (V)';'(d)'});
ylabel('{\itg_d_s_1}  (S)'); 
grid;

%format_and_save(h1, 'Fig4_22', 'W', 5.2, 'H', 4.6);

