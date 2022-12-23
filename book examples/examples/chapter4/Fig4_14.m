% 4.2.1   compare 1st,2d and 3d EKV predicted derivatives to real 
clear all
close all
addpath ../../lib
load 65nch.mat

% data (same as Fig. 4.12 ==================
L   = .1;
VG  = (.0:.025:1.2)'; 
VD  = .6;

% compute ==================
ID = lookup(nch,'ID_W','VGS',VG,'VDS',VD,'L',L);
gm = lookup(nch,'GM_W','VGS',VG,'VDS',VD,'L',L);
gm_ID = gm./ID;

UG = .5*(VG(1:end-1) + VG(2:end));

gm_2 = diff(gm)./diff(VG);
gm_prime = interp1(UG,gm_2,VG,'spline');

gm_3 = diff(gm_prime)./diff(VG);
gm_prime_prime = interp1(UG,gm_3,VG,'spline');

VGS3o = interp1(gm_3(20:end),UG(20:end),0,'cubic')
gm_ID3 = lookup(nch,'GM_ID','VGS',VGS3o,'L',L)

% EKV ===================
y = XTRACT(nch,L,VD,0,.7);
n = y(2); VT = y(3); IS = y(4); UT = .026;
q = logspace(-3,1,50);
VP = UT*(2*(q-1)+log(q));
VGS = n*VP + VT;
A   = 1/(n*UT);
gm1 = IS*A*q;
gm2 = IS*A^2*q./(2*q+1);
gm3= IS*A^3*q./(2*q+1).^3;
gmID = A./(1+q);


% plot =======================
h1 = figure(1)

subaxis(3,2,1,'Spacing', 0.1, 'MarginBottom', 0.13, 'MarginTop', 0.05, 'MarginLeft', 0.12, 'MarginRight', 0.03); 
    plot(VG,gm,'k--',VGS,gm1,'k','linewidth',1); ylabel('S') 
    text(.07,.0007,'{\itg_m_1}'); 
    xlabel('(a)');
    grid; axis([0 1.2 0 1e-3])
subaxis(3,2,3); plot(VG,gm_prime,'k--',VGS,gm2,'k','linewidth',1); ylabel('S / V') 
    text(.07,1.2e-3,'{\itg_m_2}');
   	xlabel('(b)');
    axis([0 1.2 -6e-4 2e-3]); grid
subaxis(3,2,5); plot(VG,gm_prime_prime,'k--',VGS,gm3,'k','linewidth',1); ylabel('S / V^2') 
    text(.07,5e-3,'{\itg_m_3}'); 
    axis([0 1.2 -10e-3 10e-3]); grid 
    xlabel({'{\itV_G_S}     (V)';'(c)'}); 
    
subaxis(3,2,2,'Spacing', 0.1, 'MarginBottom', 0.15, 'MarginTop', 0.05, 'MarginLeft', 0.1, 'MarginRight', 0.03); 
    plot(gm_ID,gm,'k--',gmID,gm1,'k','linewidth',1);  
    text(22,.0007,'{\itg_m_1}'); 
    xlabel('(d)');
    grid; axis([0 30 0 1e-3])
subaxis(3,2,4); plot(gm_ID,gm_prime,'k--',gmID,gm2,'k','linewidth',1);  
    text(22,1.2e-3,'{\itg_m_2}');
   	xlabel('(e)');
    axis([0 30 -6e-4 2e-3]); grid
subaxis(3,2,6); plot(gm_ID,gm_prime_prime,'k--',gmID,gm3,'k','linewidth',1);  
    text(22,5e-3,'{\itg_m_3}'); 
    axis([0 30 -10e-3 10e-3]); grid 
    xlabel({'{\itg_m}/{\itI_D}     (S/A)';'(f)'}); 
    
%format_and_save(h1, 'FIG4_14', 'W', 5.3, 'H', 5);  







