% Example 3.4   Av0 and L for cst fT sizing     
clear all
close all
addpath ../../lib
load 65nch.mat

% data ============================
JD = logspace(-10,-4.2,50); % (A/µm)
L = [.1 .2 .5 1]';          % (µm)
Aref = 50;                  % 

% compute =========================
load 65nch.mat

Av0 = lookup(nch,'GM_GDS','ID_W',JD,'L',L)';
fT  = 1e-9*lookup(nch,'GM_CGG','ID_W',JD,'L',L)'/(2*pi);
gm_ID  = lookup(nch,'GM_ID','ID_W',JD,'L',L)';

for k = 1:length(L),
    gmID1(k,1) = interp1(Av0(:,k),gm_ID(:,k),Aref);
    fT1(k) = (interp1(gm_ID(:,k),fT(:,k),gmID1(k)));
end

X1 = [0 35]; 
Y1 = Aref*[1 1];
[X Y] = meshgrid(JD,nch.L);
[a1 b1] = contour(X,Y,lookup(nch,'GM_GDS','ID_W',JD,'L',nch.L),Aref*[1 1]);
JD1 = a1(1,2:end)';
Lx  = a1(2,2:end)';
gm_IDx = diag(lookup(nch,'GM_ID','ID_W',JD1,'L',Lx));
fTx = 1e-9*diag(lookup(nch,'GM_CGG','ID_W',JD1,'L',Lx))/(2*pi);
z = Aref*ones(1,4); 

[fTmax idxmax] = max(fTx);
idx2 = max(find(fTx>=0.8*fTmax))  

% plot =================
h1 = figure(1);
subaxis(2,1,1, 'Spacing', 0.14, 'MarginBottom', 0.14, 'MarginTop', 0.03, 'MarginLeft', 0.13, 'MarginRight', 0.03)
plot(gm_IDx,fTx,'k-', 'linewidth', 1)
hold;
plot(gm_IDx(idxmax),fTmax,'ko', gm_IDx(idx2), fTx(idx2),'k*','linewidth',1.05); 
axis([3 32 0 8]); 
grid; 
xlabel({'{\itg_m}/{\itI_D} (S/A)'; '(a)'});
ylabel('{\itf_T}  (GHz)');

subaxis(2,1,2);
plot(gm_IDx,Lx,'k-', 'linewidth', 1)
hold;
plot(gm_IDx(idxmax),Lx(idxmax),'ko', gm_IDx(idx2), Lx(idx2),'k*','linewidth',1.05); 
plot([0 35], [0.065 0.065], 'k:', 'linewidth', 1)
axis([3 32 0 1.1]); grid 
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(b)'});
ylabel('{\itL}  (\mum)');
text(6, 0.16, '\itL_m_i_n', 'fontsize', 9)

%format_and_save(h1, 'Fig3_14', 'H', 4.5)





