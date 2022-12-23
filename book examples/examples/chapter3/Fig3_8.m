% Example 3.2   Constant gm/ID sizing
clear all
close all
addpath ../../lib
load 65nch.mat

% data ===========================
JD = logspace(-10,-4.2,50);     % (A/µm)
L = [ .1 .2 .5 1];              % (µm)
GMID = 15;                      % (S/A)


% compute ========================
Av0   = lookup(nch,'GM_GDS','ID_W',JD,'L',L)';
fT    = 1e-9*lookup(nch,'GM_CGG','ID_W',JD,'L',L)'/(2*pi);
gm_ID = lookup(nch,'GM_ID','ID_W',JD,'L',L)';

% reference transconductance efficiency
X1 = GMID*[1 1]; 
Y1 = [.1 1000]; 
P = [0 35]; 
Q = [1 1];

% const transit frequency and gain contours
[X Y] = meshgrid(JD,nch.L);
[a1 b1] = contour(X,Y,lookup(nch,'GM_ID','ID_W',JD,'L',nch.L),GMID*[1 1]);
JD1 = a1(1,2:end)';
Lx  = a1(2,2:end)';
fTx = 1e-9*diag(lookup(nch,'GM_CGG','ID_W',JD1,'L',Lx))/(2*pi);
Avx = diag(lookup(nch,'GM_GDS','ID_W',JD1,'L',Lx));

% mark L
for k = 1: length(L),
    fT1(k,1) = interp1(gm_ID(:,k),fT(:,k),15);
    Av01(k,1) = interp1(gm_ID(:,k),Av0(:,k),15);
end


% plot ==================
h = figure(1);
subaxis(1,2,1,'Spacing', 0.07, 'MarginBottom', 0.15, 'MarginTop', 0.02, 'MarginLeft', 0.06, 'MarginRight', 0.02); 
g1 = semilogy(gm_ID, Av0,'k--', 'linewidth',1); 
hold;
g2 = semilogy(gm_ID, fT, 'k', 'linewidth',1); 
semilogy(15,fT1,'ko',15,Av01,'ks', 'linewidth', 1.05, 'markersize',7);
semilogy(X1,Y1,'k','linewidth',2);

xlabel({'{\itg_m}/{\itI_D}  (S/A)';'(a)'});  
legend([g1(1) g2(2)], {'|{\itA_v_0}|', '{\itf_T} (GHz)'}, 'location', 'northwest');
axis([0 35 .1 1000]); 
grid;
set(gca, 'yminorgrid', 'off');
text(18,18,'{\itL} = 0.1µm', 'fontsize',9);
text(21,270,'{\itL} = 1µm','fontsize',9);
text(2,.6,'{\itL} = 1µm','fontsize',9);

subaxis(1,2,2);
semilogy(Lx,Avx,'k--',Lx,fTx,'k','linewidth',1); 
hold;
semilogy(L,fT1,'ko',L,Av01,'ks', 'linewidth', 1.05, 'markersize', 7);
axis([0 1.05 .1 1000]); 
set(gca, 'xtick', [0:0.2:1], 'yminorgrid', 'off');
xlabel({'{\itL}  (µm)';'(b)'}); grid; hold
legend('{|\itA_v_0|}', '{\itf_T} (GHz)', 'location', 'northwest');

%format_and_save(h, 'Fig3_8', 'W', 5.3, 'H', 4)

