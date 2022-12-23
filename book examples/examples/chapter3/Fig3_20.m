% Example 3.6   ID, W, L and FO for gain 80 and 50
clear all
close all
addpath ../../lib
load 65nch.mat
 
% data ===================
fu = 1e8;       % (GHz)
CL = 1e-12;     % (F)
FOmin = 10;


% gm and sweep range of L =========
gm = 2*pi*fu*CL;
L  = 0.06: 0.01: 1;

% (a) left part of figure =============================
Avo = 50;

% For each L, try to find a gm/ID that meets the gain spec 
Av = lookup(nch,'GM_GDS', 'VGS', nch.VGS(5:end), 'L', L);
for i= 1:length(L);
    VGSo(i) = interp1(Av(i,:)', nch.VGS(5:end), Avo, 'pchip');
end
gm_ID = diag(lookup(nch,'GM_ID', 'VGS', VGSo, 'L', L));
FO = diag(lookup(nch,'GM_CGG', 'VGS', VGSo, 'L', L))/2/pi/fu;
M  = FO > FOmin; FO1 = FO(M);
L1 = L(M);
gm_ID1 = gm_ID(M);

% Denormalize ==========
ID1 = gm./gm_ID1;
W1  = ID1./diag(lookup(nch,'ID_W', 'VGS', VGSo(M), 'L', L1));



% plot ==============
h = figure(1);
subaxis(1,2,1,'Spacing', 0.08, 'MarginBottom', 0.18, 'MarginTop', 0.03, 'MarginLeft', 0.06, 'MarginRight', 0.03); 
plot(gm_ID1,1e6*ID1,'color', 0.7*[1 1 1],'linewidth',2); 
hold
plot(gm_ID1,100*L1,'k',gm_ID1,W1,'k',gm_ID1,FO1,'k--','linewidth',1);

%[0 30], 10*[1 1],'k--','linewidth',1); 
%title('{\itA_v_o} = 50')

xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(a)'});  
axis([0 30 0 100]); 
grid; 

text(8,18,'100\cdot{\itL} (nm)', 'fontsize', 9)
text(8.5,90,'{\itI_D} (µA)', 'fontsize', 9);
text(22,70,'{\itW} (µm)', 'fontsize', 9); 
[a b] = max(FO1); 
text(gm_ID1(b)-2,a+6,'{\itFO}', 'fontsize', 9)
hold

% peak FO ============
[a b] = max(FO);
maxFO = a
L(b)
gmID = gm_ID(b)
ID = gm/gm_ID(b)
W = ID/lookup(nch,'ID_W','VGS',VGSo(b),'L',L(b))


% b right part of figure =================================
Avo = 80;

% For each L, try to find a gm/ID that meets the gain spec 
Av = lookup(nch,'GM_GDS', 'VGS', nch.VGS(5:end), 'L', L);
for i= 1:length(L);
    VGSo(i) = interp1(Av(i,:)', nch.VGS(5:end), Avo, 'pchip');
end
gm_ID = diag(lookup(nch,'GM_ID', 'VGS', VGSo, 'L', L));
FO = diag(lookup(nch,'GM_CGG', 'VGS', VGSo, 'L', L))/2/pi/fu;

M  = FO > FOmin; FO1 = FO(M);
L1 = L(M);
gm_ID1 = gm_ID(M);

% Denormalize ==========
ID1 = gm./gm_ID1;
W1  = ID1./diag(lookup(nch,'ID_W', 'VGS', VGSo(M), 'L', L1));

% plot ==============
subaxis(1,2,2);
hold
plot(gm_ID1,1e6*ID1,'color', 0.7*[1 1 1],'linewidth',2); 

plot(gm_ID1,100*L1,'k',gm_ID1,W1,'k',gm_ID1,FO1,'k--', 'linewidth',1)

xlabel({'{\itg_m}/{\itI_D} (S/A)'; '(b)'}); 
axis([0 30 0 100]); 
grid; 
hold
text(10,90,'100\cdot{\itL} (nm)', 'fontsize', 9)
text(4,55,'{\itI_D} (µA)', 'fontsize', 9)
text(22,54,'{\itW} (µm)', 'fontsize', 9)
[a b] = max(FO1); 
text(gm_ID1(b)-3,a+4,'{\itFO}', 'fontsize', 9)


%format_and_save(h, 'Fig3_20', 'W', 5.3, 'H', 3.2)



