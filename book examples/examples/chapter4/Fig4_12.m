% 4.2.1   1st,2d and 3d derivatives of IGS versus VGS  
clear all
close all
addpath ../../lib
load 65nch.mat

% data ==================
L   = .1;
VG  = (.0:.025:1.2)'; 
VD  = .6;

% compute ==================
ID = lookup(nch,'ID_W','VGS',VG,'VDS',VD,'L',L);
gm = lookup(nch,'GM_W','VGS',VG,'VDS',VD,'L',L);

UG = .5*(VG(1:end-1) + VG(2:end));

gm_2 = diff(gm)./diff(VG);
gm_prime = interp1(UG,gm_2,VG,'spline');

gm_3 = diff(gm_prime)./diff(VG);
gm_prime_prime = interp1(UG,gm_3,VG,'spline');

VGS3o = interp1(gm_3(20:end),UG(20:end),0,'cubic')
gm_ID3 = lookup(nch,'GM_ID','VGS',VGS3o,'L',L)

% plot =======================
h1 = figure(1)

subaxis(3,1,1,'Spacing', 0.1, 'MarginBottom', 0.12, 'MarginTop', 0.05, 'MarginLeft', 0.16, 'MarginRight', 0.03); 
    plot(VG,gm,'k', 'linewidth', 1); ylabel('S') 
    text(.05,.0007,'{\itg_m_1}'); 
    xlabel('(a)');
    grid; axis([0 1.2 0 1e-3])
subaxis(3,1,2); plot(VG,gm_prime,'k', 'linewidth', 1); ylabel('S/V') 
    text(.04,1.2e-3,'{\itg_m_2}');
   	xlabel('(b)');
    axis([0 1.2 -6e-4 2e-3]); grid
subaxis(3,1,3); plot(VG,gm_prime_prime,'k', 'linewidth', 1); ylabel('S/V^2') 
    text(.05,5e-3,'{\itg_m_3}'); 
    axis([0 1.2 -10e-3 10e-3]); grid 
    xlabel({'{\itV_G_S}     (V)';'(c)'}); 
    
%format_and_save(h1, 'Fig4_12', 'H', 5);  



