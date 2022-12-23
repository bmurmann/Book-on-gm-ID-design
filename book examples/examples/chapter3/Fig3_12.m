% Example 3.3   W and Av0 versus ID for fT = FO*fu
clear all
close all
addpath ../../lib
load 65nch.mat

% data ============
FT = 10;

% compute ========================
LL  = nch.L;
fT  = lookup(nch,'GM_CGG','L',LL)/(2*pi); 

[X Y] = meshgrid(nch.VGS,LL);
H1  = contour(X,Y,fT/1e9,FT*[1 1]); 
VGS = H1(1,2:end);
L   = H1(2,2:end);

gmID = diag(lookup(nch,'GM_ID','VGS',VGS,'L',L));
Avo = diag(lookup(nch,'GM_GDS','VGS',VGS,'L',L)); 
JD  = diag(lookup(nch,'ID_W','VGS',VGS,'L',L)); 

% max gain =============
[a b] = max(Avo);
A1 = a
L1 = L(b)
gmIDmax = gmID(b)
VGS1 = VGS(b)


% min pow consumption ==============   
[c d] = max(gmID); 
gmIDmin = gmID(d)
A2 = Avo(d)
L2 = L(d)
VGS2 = VGS(d)
   

% de-norm =========================
gm = 2*pi*FT*1e8*1e-12;
ID = gm./gmID;
W  = ID./JD;

ID1 = ID(b)
W1  = ID1/JD(b) 

ID2 = ID(d)
W2  = ID2/JD(d) 
    
% plot ============================
h1 = figure(1);
plot(1e3*ID,Avo,'k--',1e3*ID(b),a,'ko',1e3*ID(d),Avo(d),'k*',1e3*ID,W,'k',1e3*ID(b),W(b),'ko',1e3*ID2,W2,'k*','linewidth',1.05); 
axis([0 3 0 120]); grid   
xlabel('{\itI_D}   (mA)');
text(0.17,40,'|{\itA_v_0}|');
text(0.41,80,'{\itW} (\mum)');

%format_and_save(h1, 'Fig3_12')

