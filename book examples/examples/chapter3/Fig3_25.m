% Example 3.8   Opt pch load transistor
clear all
close all
addpath ../../lib
load 65nch.mat
load 65pch.mat

% data ================================================
fu = 1e9;           % (Hz)
FO = 10;            %
CL = 1e-12;         % (F)
L1 = .06: .001: .2; % (µm) 
gm_ID2 = 10;        % (S/A)


% compute ========================
gm_ID1  = lookup(nch,'GM_ID','GM_CGG',2*pi*fu*FO,'L',L1);  % column vector [L1]
gds_ID1 = diag(lookup(nch,'GDS_ID','GM_ID',gm_ID1,'L',L1));

L2 = [.06 .1*(1:10)];
gds_ID2 = lookup(pch,'GDS_ID','GM_ID',gm_ID2,'L',L2);
for k = 1:length(L2)
    Av0(:,k) = gm_ID1./(gds_ID1 + gds_ID2(k));
end

% Av0 is a matrix [L1 L2]
[a b] = max(Av0);
maxgain = a';   % row vector [L2]
%L1(b) gate lengths of M1 making Av0 max
%gm_ID1(b);

Cself = 0;
 
for k = 1:10,
    gm = 2*pi*fu*(CL+Cself);
    ID = gm./gm_ID1(b);
    W1 = ID./diag(lookup(nch,'ID_W','GM_ID',gm_ID1(b),'L',L1(b)));
    W2 = ID./lookup(pch,'ID_W','GM_ID',gm_ID2,'L',L2);
    Cdd2 = W2.*lookup(pch,'CDD_W','GM_ID',gm_ID2,'L',L2); 
    Cdd1 = W1.*diag(lookup(nch,'CDD_W','GM_ID',gm_ID1(b),'L',L1(b)));  
    Cself = Cdd1 + Cdd2; 
end

recapitulative = interp1(L2,[maxgain 1e6*ID gm_ID1(b) L1(b)' W1 W2],.5)

% plot ==========================
h = figure(1);

subaxis(1,2,1,'Spacing', 0.08, 'MarginBottom', 0.2, 'MarginTop', 0.03, 'MarginLeft', 0.06, 'MarginRight', 0.02); 
ax = plot(L2,[W1 W2 1e3*L1(b)'],'k');
set(ax(1), 'linewidth', 1);
set(ax(2), 'linewidth', 1);
set(ax(3), 'linewidth', 1);
grid;
xlabel({'{\itL_2}   (µm)','(a)'},'fontsize', 9)
text(.5,310,'{\itW_2}  (µm)','fontsize', 9)
text(.7,95,'{\itW_1}  (µm)','fontsize', 9)
text(.7,200,'{\itL_1}  (nm)','fontsize', 9)

subaxis(1,2,2)
ax = plot(L2,[1e6*ID 10*maxgain],'k'); 
grid;
set(ax(1), 'linewidth', 1);
set(ax(2), 'linewidth', 1);
xlabel({'{\itL_2}   (µm)','(b)'},'fontsize', 9)
text(.6,510,'{\itI_D}  (µA)','fontsize', 9)
text(.6,290,'10 x |{\itA_v_0_m_a_x}|','fontsize', 9)

%format_and_save(h, 'Fig3_25', 'W', 5.3)

