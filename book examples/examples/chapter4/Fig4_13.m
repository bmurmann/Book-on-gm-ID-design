% 4.2.1   check Taylor exp reconstructed ID(VGS) against original
clear all
close all
addpath ../../lib
load 65nch.mat

% data ==================
L   = .1;
VG  = (.0:.025:1.2)'; 
VD  = .6;

% compute ==================
ID = lookup(nch,'ID','VGS',VG,'VDS',VD,'L',L);
gm = lookup(nch,'GM','VGS',VG,'VDS',VD,'L',L);

UG = .5*(VG(1:end-1) + VG(2:end));

gm_2 = diff(gm)./diff(VG);
gm_prime = interp1(UG,gm_2,VG,'spline');

gm_3 = diff(gm_prime)./diff(VG);
gm_prime_prime = interp1(UG,gm_3,VG,'spline');

gm_4 = diff(gm_prime_prime)./diff(VG);
gm_prime_prime_prime = interp1(UG,gm_4,VG,'spline');

k  = 19;    
P = [1/24*gm_prime_prime_prime(k) 1/6*gm_prime_prime(k) .5*gm_prime(k) gm(k) ID(k)]


% error bounds ---------------------------
er = .01;
h2 =figure(1)

subaxis(2,2,1,'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.12, 'MarginRight', 0.03); 

ITaylor = polyval(P(4:5),VG - VG(k));
y = find(abs(1-ID./ITaylor)<=er);
semilogy(VG,ID,'k',VG,ITaylor,'k--',VG(k)*[1 1],ID(k)*[.1 15],'k','linewidth',1); grid;
axis([0 1.2 1e-10 1e-2]); 
xlabel('(a)');xlabel({'{\itV_G_S}  (V)';'(a)'}); 
ylabel('{\itI_D}   (A)'); hold
semilogy(VG(y),ID(y),'k*'); hold

subaxis(2,2,2)
ITaylor = polyval(P(3:5),VG - VG(k));
y = find(abs(1-ID./ITaylor)<=er);
semilogy(VG,ID,'k',VG,ITaylor,'k--',VG(k)*[1 1],ID(k)*[.1 15],'k','linewidth',1); grid;
axis([0 1.2 1e-10 1e-2]); 
xlabel('(b)'); hold; xlabel({'{\itV_G_S}  (V)';'(b)'}); 
semilogy(VG(y),ID(y),'k','linewidth',3); hold

subaxis(2,2,3)
ITaylor = polyval(P(2:5),VG - VG(k));
y = find(abs(1-ID./ITaylor)<=er);
semilogy(VG,ID,'k',VG,ITaylor,'k--',VG(k)*[1 1],ID(k)*[.1 15],'k','linewidth',1); grid;
axis([0 1.2 1e-10 1e-2]); xlabel({'{\itV_G_S}  (V)';'(c)'}); ylabel('{\itI_D}   (A)'); hold
semilogy(VG(y),ID(y),'k','linewidth',3); hold

subaxis(2,2,4)
ITaylor = polyval(P(1:5),VG - VG(k));
y = find(abs(1-ID./ITaylor)<=er);
semilogy(VG,ID,'k',VG,ITaylor,'k--',VG(k)*[1 1],ID(k)*[.1 15],'k','linewidth',1); grid;
axis([0 1.2 1e-10 1e-2]); xlabel({'{\itV_G_S}  (V)';'(d)'}); hold
semilogy(VG(y),ID(y),'k','linewidth',3); hold

%format_and_save(h2, 'Fig4_13', 'W', 5.3, 'H', 5)




