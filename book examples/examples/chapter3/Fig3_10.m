% Example 3.3   Constant fT sizing
clear all
close all
addpath ../../lib
load 65nch.mat


% data ===========================
JD = logspace(-10,-4.2,50);   % (A/µm)
L = [ .1 .2 .3 .4 ]';       % (µm)
FT = 10;                    % (GHz)


% compute ========================
Av0 = lookup(nch,'GM_GDS','ID_W',JD,'L',L)';
fT  = 1e-9*lookup(nch,'GM_CGG','ID_W',JD,'L',L)'/(2*pi);
gm_ID = lookup(nch,'GM_ID','ID_W',JD,'L',L)';

for k = 1:length(L),
    gmID1(k,1) = interp1(fT(:,k),gm_ID(:,k),FT);
    Av01(k)    = (interp1(gm_ID(:,k),Av0(:,k),gmID1(k)));
end

% referenece transit frequency
X1 = [0 35]; 
Y1 = FT*[1 1];

% const gm=ID and gain contours
[X Y] = meshgrid(JD,nch.L);
[a1 b1] = contour(X,Y,1e-9*lookup(nch,'GM_CGG','ID_W',JD,'L',nch.L)/(2*pi),FT*[1 1]);
JD1 = a1(1,2:end)';
Lx  = a1(2,2:end)';
gm_IDx = diag(lookup(nch,'GM_ID','ID_W',JD1,'L',Lx));
Avx = diag(lookup(nch,'GM_GDS','ID_W',JD1,'L',Lx));
z = FT*ones(4,1); 

% plot =================
h = figure(1);
subaxis(1,2,1,'Spacing', 0.07, 'MarginBottom', 0.15, 'MarginTop', 0.02, 'MarginLeft', 0.06, 'MarginRight', 0.02); 
g1 = semilogy(gm_ID,Av0,'k--', 'linewidth',1); 
hold;
g2 = semilogy(gm_ID,fT,'k','linewidth',1); 
semilogy(gmID1(:,ones(1,2))',[z Av01']','k:'); 
semilogy(X1,Y1, 'color', [0.7 0.7 0.7],'linewidth',2); 
semilogy(gm_IDx,Avx,'k','linewidth',2); 
semilogy(gmID1,Av01,'ko', 'linewidth',1); 
xlabel({'{\itg_m}/{\itI_D}  (S/A)';'(a)'});  
axis([0 35 1 100]);
set(gca, 'ygrid', 'on', 'yminorgrid', 'off');
legend([g1(1) g2(1)], {'|{\itA_v_0}|', '{\itf_T} (GHz)'}, 'location', 'southwest');
text(3.5,80,'{\itL} = 0.4µm', 'fontsize',9);
text(23,22,'{\itL} = 0.1µm', 'fontsize',9);
text(24.5,7,'{\itL} = 0.1µm', 'fontsize',9);
text(1,3.2,'{\itL} = 0.4µm', 'fontsize',9);

subaxis(1,2,2);
semilogy(Lx,Avx,'k--',Lx,gm_IDx,'k','linewidth',1);
hold;
semilogy(L,Av01,'ok',L,gmID1,'ok','linewidth',1); 
axis([0 .5 1 100]); 
grid;
set(gca, 'yminorgrid', 'off');
xlabel({'{\itL}  (µm)';'(b)'}); 
text(.12,6.5,'{\itg_m/I_D}  (S/A)', 'fontsize',9); 
text(.22,50,'|{\itA_v_0}|', 'fontsize',9);

%format_and_save(h, 'Fig3_10','W',5.3,'H',4)



