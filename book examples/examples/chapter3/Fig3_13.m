% Example 3.4   Constant Av0 sizing
clear all
close all
addpath ../../lib
load 65nch.mat


% data ============================
JD = logspace(-10,-4.2,50);
L = [.1 .2 .5 1]'; 
Aref = 50;

% compute =========================
Av0 = lookup(nch,'GM_GDS','ID_W',JD,'L',L)';
fT  = 1e-9*lookup(nch,'GM_CGG','ID_W',JD,'L',L)'/(2*pi);
gm_ID  = lookup(nch,'GM_ID','ID_W',JD,'L',L)';

for k = 1:length(L),
    gmID1(k,1) = interp1(Av0(:,k),gm_ID(:,k),Aref);
    fT1(k)  = (interp1(gm_ID(:,k),fT(:,k),gmID1(k)));
end

% referenece gain
X1 = [0 35]; 
Y1 = Aref*[1 1];

% const gm=ID and transit frequency contours
[X Y] = meshgrid(JD,nch.L);
[a1 b1] = contour(X,Y,lookup(nch,'GM_GDS','ID_W',JD,'L',nch.L),Aref*[1 1]);
JD1 = a1(1,2:end)';
Lx  = a1(2,2:end)';
gm_IDx = diag(lookup(nch,'GM_ID','ID_W',JD1,'L',Lx));
fTx = 1e-9*diag(lookup(nch,'GM_CGG','ID_W',JD1,'L',Lx))/(2*pi);
z   = Aref*ones(1,4); 


% plot =================
h = figure(1);

subaxis(1,2,1,'Spacing', 0.07, 'MarginBottom', 0.15, 'MarginTop', 0.02, 'MarginLeft', 0.06, 'MarginRight', 0.02); 
g1 = semilogy(gm_ID,Av0,'k--', 'linewidth', 1);
hold;
semilogy((gmID1*[1 1])',[fT1; z],'k:');
g2 = semilogy(gm_ID,fT,'k', 'linewidth', 1);
semilogy(X1,Y1,'color', [0.7 0.7 0.7],'linewidth',2);
semilogy(gm_IDx,fTx,'k','linewidth',2);
semilogy(gmID1,fT1,'ko','linewidth',1);
xlabel({'{\itg_m}/{\itI_D}  (S/A)';'(a)'});  
axis([0 31 .2 200]);
legend([g1(1) g2(1)], {'|{\itA_v_0}|', '{\itf_T} (GHz)'}, 'location', 'southwest');
text(9,160,'{\itL} = 1µm','fontsize',9);  
text(1,.95,'{\itL} = 1µm','fontsize',9)
text(17,18,'{\itL} = 0.1µm','fontsize',9)

subaxis(1,2,2); semilogy(Lx,fTx,'k',Lx,gm_IDx,'k','linewidth',1); 
hold;
semilogy(L,fT1,'ok',L,gmID1,'ok','linewidth',1); 
semilogy([0 1], [1 1]*0.9*max(fT1),'k-.', 'linewidth',1); 
xlabel({'{\itL} (µm)';'(b)'});
axis([0 1 .2 200]); 
grid;
set(gca, 'yminorgrid', 'off');
text(.25,20,'{\itg_m}/{\itI_D}  (S/A)','fontsize',9); 
text(.25,2.5,'{\itf_T}  (GHz)','fontsize',9); 

%format_and_save(h, 'Fig3_13','W',5.3,'H',4)

