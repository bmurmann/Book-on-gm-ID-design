% 5.2   two transistor current mirror
clear all
close all
addpath ../../lib
load 65nch.mat

% data
L = .5;
gmID1 = 20;
ID = 1e-4;


% M1 (VDS1 = VGS1)=================
VGS1 = lookupVGS(nch,'GM_ID',gmID1,'L',L);
VDS1 = VGS1
VGS1 = lookupVGS(nch,'GM_ID',gmID1,'VDS',VDS1,'L',L);
JD1  = lookup(nch,'ID_W','VGS',VGS1,'VDS',VDS1,'L',L);
gds1 = lookup(nch,'GDS_W','VGS',VGS1,'VDS',VDS1,'L',L);
VEA1 = JD1./gds1
Rout = VEA1/ID;

% example ==================
ID1 = 1e-4;
W   = ID1/JD1

Vout = .01*(0:120);
ID3  = W*lookup(nch,'ID_W','VGS',VGS1,'VDS',Vout,'L',L); 
gds3 = W*lookup(nch,'GDS_W','VGS',VGS1,'VDS',Vout,'L',L); 

% plot ==============
h = figure(1);
subaxis(2,1,1,'Spacing', 0.14, 'MarginBottom', 0.14, 'MarginTop', 0.04, 'MarginLeft', 0.13, 'MarginRight', 0.03); 


plot(Vout,ID3,'k',VDS1,ID1,'ok','linewidth',1); 
grid; axis([0 1.2 0 1.4e-4]); 
xlabel({'{\itV_O_U_T}  (V)';'(a)'}); ylabel('{\itI_O_U_T}  (A)');

subaxis(2,1,2);
plot(Vout,1./gds3,'k',VDS1,VEA1/ID,'ok','linewidth',1); 
grid; axis([0 1.2 0 1e5]);
xlabel({'{\itV_O_U_T}  (V)';'(b)'});  ylabel('{\itR_o_u_t}  (\Omega)');

%format_and_save(h, 'Fig5_8', 'H', 4.5)


