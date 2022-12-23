% Example 3.6   2D contour plot of cst Av0 and fT 
clear all
close all
addpath ../../lib
load 65nch.mat
 
% data ==============================
fu = 1e8;       % (Hz)
CL = 1e-12;     % (F)
FOmin = 10;     % transit freq = FOmin*fu
A = 80;         % desired gain




% compute ================================
L  = .06:.01:1; 
JDmin = -10; JD = logspace(JDmin,-4.5,100);
[X Y] = meshgrid(JD,L);

% transit freq contour, search max gain and gm/ID =================
fT_1 = lookup(nch,'GM_CGG','ID_W',JD,'L',L)/(2*pi);
[a1 b1] = contour(X,Y,fT_1,FOmin*fu*[1 1],'linewidth',1); 
JD1 = a1(1,2:end)';
L1  = a1(2,2:end)';
Av  = diag(lookup(nch,'GM_GDS', 'ID_W', JD1, 'L', L1));
[a2 b2] = max(Av); 
L2  = L1(b2);
JD2 = JD1(b2);
gmID2 = lookup(nch,'GM_ID','ID_W',JD2,'L',L2)

% plot max gain contour ===============
Av2  = lookup(nch,'GM_GDS','ID_W',JD,'L',L);    %[L,JD)
[a5 b5] = contour(X,Y,Av2,a2*[1 1]); 
JD5 = a5(1,2:end)';
L5  = a5(2,2:end)';

% find JD4 and L4 making gain = A ===================
[a3 b3] = contour(X,Y,Av2,A*[1 1]); 
JD3    = a3(1,2:end)';
L3     = a3(2,2:end)';

% find JD4, L4 and gm/ID4 making FO > FOMin =============
FO  = diag(lookup(nch,'GM_CGG', 'ID_W', JD3, 'L', L3))/(2*pi*fu);
M   = FO >= FOmin; 
FO4 = FO(M);
JD4 = JD3(M);
L4  = L3(M);
gm_ID4 = diag(lookup(nch,'GM_ID','ID_W',JD4,'L',L4));

M = min(gm_ID4)
N = max(gm_ID4)

% find gm/ID contours ============
gmID6  = lookup(nch,'GM_ID','ID_W',JD,'L',L);    %[L,JD)
[a6 b6] = contour(X,Y,gmID6,20*[1 1]); 
JD6 = a6(1,2:end)';
L6  = a6(2,2:end)';

[a7 b7] = contour(X,Y,gmID6,15*[1 1]); 
JD7 = a7(1,2:end)';
L7  = a7(2,2:end)';

[a8 b8] = contour(X,Y,gmID6,25*[1 1]); 
JD8 = a8(1,2:end)';
L8  = a8(2,2:end)';


% plot ==========================
h = figure(1); 
plot(log10(JD1),L1,'k-','linewidth',2); 
hold 
plot(log10(JD5),L5,'k-','linewidth',1);
plot(log10(JD3),L3,'k--','linewidth',1);
plot(log10(JD2),L2,'ko','linewidth',2);
legend('{\itf_T} = 1 GHz', '{|\itA_v_0}| = max.', '|{\itA_v_0}| = 80', 'location','NorthWest');

plot(log10(JD6),L6,'color',0.7*[1 1 1],'linewidth',2); 
plot(log10(JD7),L7,'color',0.7*[1 1 1],'linewidth',2);
plot(log10(JD8),L8,'color',0.7*[1 1 1],'linewidth',2);
text(-5.1,0.91,'A', 'fontsize', 9)
text(-6.85,0.2,'B', 'fontsize', 9)
text(-6,0.15,'25    20    15', 'fontsize', 9)
text(-5,.3,{'{\itg_m}/{I_D}','(S/A)'}, 'fontsize', 9);
axis([JDmin -4 .06 1]); 
grid
xlabel({'log_1_0({\itJ_D}  (A/µm))'}); 
ylabel('{\itL}  (µm)'); 
hold

% data for Fig2_20.m ===============
max(gm_ID4)
min(L4)
gm = 2*pi*fu*CL;
ID4 = gm/max(gm_ID4)
W4 = ID4/min(JD4)

%format_and_save(h, 'Fig3_19')

