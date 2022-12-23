% 3.1.6   Sizing using JD: 2D contour plots of cst Avo, gm/ID and fT 
clear all
close all
addpath ../../lib
load 65nch.mat

% data =========================
L  = nch.L;                     % (µm)
JD = logspace(-11,-4.2,50);     % (A/µm)

% compute ==================
[X Y] = meshgrid(log10(JD),L);
Avo  = lookup(nch,'GM_GDS','ID_W',JD,'L',L);
fT   = 1e-9*lookup(nch,'GM_CGG','ID_W',JD,'L',L)/(2*pi);
gmID = lookup(nch,'GM_ID','ID_W',JD,'L',L);

% plot ====================
h1 = figure(1);

subaxis(3,1,1,'Spacing', 0.07, 'MarginBottom', 0.1, 'MarginTop', 0.01, 'MarginLeft', 0.12, 'MarginRight', 0.03); 
[C,H2] = contour(X,Y,gmID,5*(1:6),'k-', 'linewidth',1); 
clabel(C,H2,'FontSize',8); 
hold
X2 = log10(5.83e-4/46.6); % high freqency IGS
Y2 = 0.217;
plot(X2,Y2,'ko',-9.7959,.5,'k+','linewidth',2); 
hold
text(-10,.7,'{\itg_m}/{\itI_D}  (S/A)', 'fontsize', 9, 'edgecolor', 'k'); 
xlabel('(a)'); 
ylabel('{\itL}  (µm)'); 
grid; 

subaxis(3,1,2); 
[C,h] = contour(X,Y,Avo,50*(1:10),'k-','linewidth',1); 
clabel(C,h,'FontSize',8); 
hold
plot(X2,Y2,'ko',-9.7959,.5,'k+','linewidth',2); 
axis([-11 -4 0.06 1]); 
text(-9.5,0.65,'{\itA_i_n_t_r}', 'fontsize', 9, 'edgecolor', 'k');  
xlabel('(b)');
ylabel('{\itL}  (µm)'); 
grid; 
hold 

subaxis(3,1,3); [C,H3] = contour(X,Y,fT,logspace(-3,1,5),'k-','linewidth',1); 
clabel(C,H3,'FontSize',8); 
hold
plot(X2,Y2,'ko',-9.7959,.5,'k+','linewidth',2); 

xlabel({'log_1_0({\itJ_D} (A/\mum))';'(c)'});  
ylabel('{\itL}  (µm)'); 
grid; 
text(-10.8,0.8,'{\itf_T}  (GHz)', 'fontsize', 9, 'edgecolor', 'k'); 
hold

%format_and_save(h1, 'Fig3_18', 'W', 5, 'H', 6.5)





