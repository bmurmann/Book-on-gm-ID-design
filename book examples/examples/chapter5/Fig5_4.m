% Example 5.1   Sizing a consant gm bias circuit
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat 

% data ======
VDD = 1.2;
VGS = linspace(0.4, 0.8, 50);
L  = 0.5;
VR = .1;
ID = 5e-5;

% compute ================
JD2 = diag(lookup(nch,'ID_W','VGS',VGS,'VDS',VGS,'L',L));
JD1 = diag(lookup(nch,'ID_W','VGS',VGS-VR,'VDS',VGS-VR,'L',L));
JD3 = diag(lookup(pch,'ID_W','VGS',VDD-VGS,'VDS',VDD-VGS,'L',L));

gm_ID2 = diag(lookup(nch,'GM_ID','VGS',VGS,'VDS',VGS,'L',L));
gm_ID1 = diag(lookup(nch,'GM_ID','VGS',VGS-VR,'VDS',VGS-VR,'L',L));
gm_ID3 = diag(lookup(pch,'GM_ID','VGS',VDD-VGS,'VDS',VDD-VGS,'L',L));

W2 = ID./JD2;
W1 = ID./JD1;
W3 = ID./JD3;

% choose w2 ======================
w2 = 15;
w1 = interp1(W2,W1,w2);
w3 = interp1(W2,W3,w2);
widths = [w1 w2 w3]

gm_Id1 = interp1(W2,gm_ID1,w2);
gm_Id2 = interp1(W2,gm_ID2,w2);
gm_Id3 = interp1(W2,gm_ID3,w2);
gm_IDs = [gm_Id1 gm_Id2 gm_Id3 ] 

Vgs = interp1(W2,VGS,w2)

gm2 = w2*lookup(nch,'GM_W','VGS',Vgs,'VDS',Vgs,'L',L)

% plot =======================
h = figure(1);
subaxis(2,1,1,'Spacing', 0.13, 'MarginBottom', 0.12, 'MarginTop', 0.02, 'MarginLeft', 0.13, 'MarginRight', 0.02); 
semilogy(gm_ID2,W1,'k',gm_ID2,W2,'k--',gm_ID2,W3,'k','linewidth',1);
xlabel({'({\itg_m}/{\itI_D})_2  (S/A)';'(a)'})
ylabel('Widths  (\mum)');
text(15,2*W1(10),'M_1');
text(15,2*W2(10),'M_2');
text(15,1.7*W3(10),'M_3');
axis([5 20 1 1000]); grid
set(gca, 'yminorgrid', 'off');

subaxis(2,1,2); plot(gm_ID2,gm_ID1,'k',gm_ID2,gm_ID2,'k--',gm_ID2,gm_ID3,'k','linewidth',1); 
xlabel({'({\itg_m}/{\itI_D})_2  (S/A)';'(b)'})
ylabel('{\itg_m}/{\itI_D}  (S/A)');
text(15,gm_ID1(10)+1.5,'M_1');
text(15,gm_ID2(10)+3,'M_2');
text(15,gm_ID3(10)+2,'M_3');
axis([5 20 0 30]); grid

%format_and_save(h, 'Fig5_4', 'H', 5)




