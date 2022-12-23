% 4.2.3   size IGS to make HD2 = 0 
clear all
close all
addpath ../../lib
load 65nch.mat;
load 65pch.mat;

% data (nch) ===============
L = .1;             
gm_ID = 3:.1:25;   	

% 1) compute 2D Taylor expansion coeff (vert VGS, horiz VDS) =======
VDS = 0.6;
VGS  = lookupVGS(nch,'GM_ID',gm_ID,'L',L);

y = blkm(nch,L,VDS,VGS);
    
gm1 = y(:,1,1)
gd1 = y(:,1,2)
JD1 = y(:,1,3)
gm2 = y(:,1,4)
gd2 = y(:,1,5)
x11 = y(:,1,6)

R = logspace(2,6,5);
for k = 1:length(R),
    y = 1/R(k);
    a1 = - gm1./(y + gd1);
    a2 = -(.5*gm2 + x11.*a1 + .5*gd2.*a1.^2)./(y + gd1);
    HD2(:,k) = 20*log10(.5*abs(a2./a1)*.01);
end
    
h = figure(1);   
plot(gm_ID,HD2(:,1),'k--','linewidth',2); 
hold;
plot(gm_ID,HD2(:,2),'k--','linewidth',1); 
plot(gm_ID,HD2(:,3),'k:','linewidth',1); 
plot(gm_ID,HD2(:,4),'k','linewidth',2); 
plot(gm_ID,HD2(:,5),'k-.','linewidth',1); 
axis([2 25 -100 -20]);
xlabel('{\itg_m}/{\itI_D}  (S/A)');
ylabel('HD_2  (dB)');
grid;
legend('100 \Omega', '1 k\Omega', '10 k\Omega', '100 k\Omega', '1 M\Omega', 'location', 'southeast');

%format_and_save(h, 'Fig4_25')

    






