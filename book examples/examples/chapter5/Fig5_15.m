% 5.3.2   frequency response of LDO       
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat

% Load data from Sizing_LDO1.m
load Fig5_15.mat

% poles & zeros =============
C  = 10.^(-(6:.2:12)); 

M = (Cgs+Cgd*(1+A))/gda + (C+Cgd)/(Y+gds);
fp1 = 1./M/(2*pi)
fp2 = M.*(gda*(Y+gds))./((Cgs+Cgd)*C + Cgd*Cgs)/(2*pi)
fz  = gm/Cgd/(2*pi)
%GBW = A*Aa*fp1

h1 = figure(1); 
subaxis(1,2,1,'Spacing', 0.10, 'MarginBottom', 0.17, 'MarginTop', 0.02, 'MarginLeft', 0.11, 'MarginRight', 0.03); 
loglog(C,-fp1,'k',C,-fp2,'k','linewidth',1); 
axis([1e-12 1e-6 -1e10 -2e2])
text(1e-10,-.5e4,'Dominant pole ({\itp_1})', 'fontsize', 9)
text (3e-11,-1e9,'Non-dominant pole ({\itp_2})', 'fontsize', 9)
xlabel({'{\itC_L}  (F)';'(a)'}); ylabel('(Hz)')
grid;
set(gca, 'yminorgrid', 'off');

% closed LOOP =====================
C   = 10.^(-(6:12)); 
Y   = ID/V; 
Cm  = Cgd;
C1  = Cgs;
gm1 = gma;
gd1 = gda;
gm2 = gm;
gd2 = gds + Y;
for k = 1:length(C),
    C2 = C(k);
    D = [(C1*C2 + C1*Cm + C2*Cm) (C1*gd2 + C2*gd1 + Cm*gd1 +...
        Cm*gd2 + Cm*gm2) gd1*gd2]; P(k,:) = roots(D);
    N = [-Cm*gm1 gm1*gm2];   
    w   = logspace(4,12,500);  s = j*w;
    den = polyval(D,s); 
    num = polyval(N,s);
    M = num./den; H(k,:) = M; 
    wu(k,1) = interp1(abs(M),w,1);
    a(k,1)  = interp1(w,angle(M),wu(k));
end

fu  = wu/(2*pi);
ang = 180/pi*a;

subaxis(1,2,2); 
semilogx(w/(2*pi),20*log10(abs(H./(1+H))),'k','linewidth',1); 
grid; 
axis([1e4 1e10 -50 15]); 
ylabel('|{\itv_o_u_t}/{\itv_r_e_f}|  (dB)');
text(.5e6,-20,'1 µF', 'fontsize', 9)
text(1.5e9,-6,'1 pF', 'fontsize', 9)
xlabel({'{\itf}  (Hz)';'(b)'}); 

%format_and_save(h1, 'Fig5_15', 'W', 5.3, 'H', 3.8) 
















return
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat  

% data =======================
VDD = 1.2;         % supply voltage     
V   = .9;          % desired regulated voltage
ID   = .01;        % desired current (Y = 1D/V)
L   = .2;
Lp  = .5;
Ln  = .5;
C   = 1e-12;

gm_ID  = 10; 
gm_IDn = 15; 
IDa    = 1e-4;

% pch series transistor M ======================
VDS = VDD - V;
JD  = lookup(pch,'ID_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
gm  = gm_ID*ID;
W   = ID./JD
gds = W.*lookup(pch,'GDS_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
VGS = lookupVGS(pch,'GM_ID',gm_ID,'VDS',VDS,'L',L);
Y   = ID/V; 
A   = gm./(Y+gds);
V1  = VDD - VGS;
Cgs = W.*lookup(pch,'CGS_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
Cgd = W.*lookup(pch,'CGD_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
  
% current mirror ==================   
gds_IDp = lookup(pch,'GDS_ID','VGS',VGS,'VDS',VGS,'L',Lp);

% diff-amp (VSB = 0 V) ============
US   = V - lookupVGS(nch,'GM_ID',gm_IDn,'VDS',.2,'L',Ln)';
UDSn = V1-V+lookupVGS(nch,'GM_ID',gm_IDn,'VDS',V1-US,'L',Ln);
VGSn = lookupVGS(nch,'GM_ID',gm_IDn,'VDS',UDSn,'L',Ln);
gds_IDn = lookup(nch,'GDS_ID','GM_ID',gm_IDn,'VDS',UDSn,'L',Ln);
Aa = gm_IDn/(gds_IDn + gds_IDp);

gain = A.*Aa;

% Wn and Wp ===============
gma = gm_IDn*IDa;
JDp = lookup(pch,'ID_W','VGS',VGS,'VDS',VGS,'L',Lp); 
Wp  = IDa/JDp
JDn = lookup(nch,'ID_W','GM_ID',gm_IDn,'VDS',UDSn,'L',Ln); 
Wn  = IDa/JDn
gda = (gds_IDp + gds_IDn)*IDa;      % verif  Aa = gm_IDn*IDa/gd1

% poles & zeros =============
C  = 10.^(-(6:.2:12)); 

M = (Cgs+Cgd*(1+A))/gda + (C+Cgd)/(Y+gds);
fp1 = 1./M/(2*pi)
fp2 = M.*(gda*(Y+gds))./((Cgs+Cgd)*C + Cgd*Cgs)/(2*pi)
fz  = gm/Cgd/(2*pi)
GBW = gain*fp1

h1 = figure(1); 
subplot(1,2,1); loglog(C,-fp1,'k',C,-fp2,'k','linewidth',1); 
axis([1e-12 1e-6 -1e10 -2e2])
text(5e-10,-.5e4,'dominant pole')
text (3e-11,-1e9,'non-dom pole')
xlabel('C    (F)'); ylabel('Hz')

% closed LOOP =====================
C   = 10.^(-(6:12)); 
Y   = ID/V; 
Cm  = Cgd;
C1  = Cgs;
gm1 = gma;
gd1 = gda;
gm2 = gm;
gd2 = gds + Y;
for k = 1:length(C),
    C2 = C(k);
    D = [(C1*C2 + C1*Cm + C2*Cm) (C1*gd2 + C2*gd1 + Cm*gd1 +...
        Cm*gd2 + Cm*gm2) gd1*gd2]; P(k,:) = roots(D);
    N = [-Cm*gm1 gm1*gm2];   
    w   = logspace(4,12,500);  s = j*w;
    den = polyval(D,s); 
    num = polyval(N,s);
    M = num./den; H(k,:) = M; 
    wu(k,1) = interp1(abs(M),w,1);
    a(k,1)  = interp1(w,angle(M),wu(k));
end

fu  = wu/(2*pi);
ang = 180/pi*a;

subplot(1,2,2); semilogx(w/(2*pi),20*log10(abs(H./(1+H))),'k'); 
grid; axis([1e4 1e10 -50 20]); ylabel('closed loop mag    (dB)');
xlabel('f        (Hz)'); 
subplot(111)

%format_and_save(h1, 'FIG5_6', 'W', 6, 'H', 4) 



return



% plot ===========================
h = figure(1),
subplot(3,1,1); 
    semilogx(w/(2*pi),20*log10(abs(H)),'k',fu,0,'+k'); 
    grid; axis([1e4 1e10 -50 50]); ylabel('open loop mag'); 

subplot(3,1,2); 
    semilogx(w/(2*pi),180/pi*(angle(H)),'k',fu,ang,'--+k');
    grid; axis([1e4 1e10 -180 0]); ylabel('open loop phase'); 

subplot(3,1,3);
    semilogx(w/(2*pi),20*log10(abs(H./(1+H))),'k',fu,0,'+k'); 
    grid; axis([1e4 1e10 -50 20]); ylabel('closed loop mag');
	xlabel('f        (Hz)');

subplot(111)

