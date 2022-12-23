%A.1.4   VT and JS plotted versus rho, param L
clear all
close all
addpath ../../lib
load 65nch.mat
load 65pch.mat

kB = 1.38e-23;
qe = 1.602e-19;
UT = kB*nch.TEMP/qe

dev = nch;

% data ============
L    = [.06 .1 .2 .5];  zL = length(L);
rho = .1*(2:.5:9)';     zR = length(rho);

% compute =========
gm_ID = lookup(dev,'GM_ID','L',L)';
[a b] = max(gm_ID);
gmIDo = a(ones(zR,1),:).*rho(:,ones(1,zL));
for m = 1:zL,
    VGS(:,m) = lookupVGS(dev,'GM_ID', gmIDo(:,m),'L', L(m));
    JD(:,m)  = lookup(dev,'ID_W','GM_ID',gmIDo(:,m),'L',L(m));
end    
    
% find  n,  VT and JS ===========
    q   = 1./rho - 1;
    q   = q(:,ones(1,length(L)));
    i   = q.^2 + q;
    JS  = JD./i;
    n   = 1./(a*UT);  
    VP  = UT*(2*(q-1) + log(q)); 
    VT  = VGS - n(ones(zR,1),:).*VP

% plot =======================
h = figure(1);
subaxis(2,1,1,'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.02, 'MarginLeft', 0.15, 'MarginRight', 0.03) 
plot(rho,VT,'k','linewidth',1); grid; 
axis([0 1 .47 .51]); 
ylabel('{\itV_T}   (V)');
g = text(.7,.499,'{\itL} = 100nm');
set(g, 'fontsize', 9);
g = text(.7,.491,'{\itL} = 60nm');
set(g, 'fontsize', 9);
g = text(.7,.483,'{\itL} = 200nm');
set(g, 'fontsize', 9);
g = text(.7,.476,'{\itL} = 500nm');
set(g, 'fontsize', 9);
xlabel({'{\it\rho}'; '(a)'}),

subaxis(2,1,2); plot(rho,JS,'k','linewidth',1); grid; 
axis([0 1 0 1e-5]); 
ylabel('{\itJ_S}   (A/\mum)');
g = text(.7,5e-6,'{\itL} = 100nm');
set(g, 'fontsize', 9);
g = text(.7,7.7e-6,'{\itL} = 60nm');
set(g, 'fontsize', 9);
g = text(.7,2.5e-6,'{\itL} = 200nm');
set(g, 'fontsize', 9);
g = text(.7,1.5e-6,'{\itL} = 500nm');
set(g, 'fontsize', 9);
xlabel({'{\it\rho}'; '(b)'}),

%format_and_save(h, 'FigA1_4', 'H', 5.5)

















return
% compute ==================
for k = 1:length(VGS),
    gmID(k,1) = round(lookup(dev,'GM_ID','VGS',VGS(k),'L',L));   % reference 
% EKV =========
    y = XTRACT2(dev,L,VDS,VSB,gmID(k));
    n = y(:,2); VT = y(:,3); IS = y(:,4);
    VP = (VGS(k) - VT)./n;                 % VP1(:,k) = VP;
    UT = .026; qS = invq(VP/UT);                       % qS1(:,k) = qS;
    IDEKV(:,k) = IS.*(qS.^2 + qS);
% real ===============
    ID(:,k) = lookup(nch,'ID_W','VDS',dev.VDS,'VGS',VGS(k),'L',L);
end

% plot ====================
semilogy(nch.VDS,ID,VDS,IDEKV,'k+'); axis([0 1 0 1.2*max(max(ID))]); grid
xlabel('V_D_S   (V)'); ylabel('I_D    (A)');

gmID



