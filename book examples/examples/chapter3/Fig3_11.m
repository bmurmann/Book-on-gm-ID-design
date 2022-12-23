% Example 3.3   Av0 and L versus gm/ID for fT = FO*fu
clear all
close all
addpath ../../lib
load 65nch.mat

% data ============
fu = 1e9;       % (Hz)         
FO = 10         %

% compute ========================
FT  = fu*FO;
LL  = nch.L;
JDD = logspace(-8,-4.2,50);

[X Y] = meshgrid(log10(JDD),LL);    
fT = lookup(nch,'GM_CGG','ID_W',JDD,'L',LL)/(2*pi); 
H1 = contour(X,Y,fT,FT*[1 1]); 
JD = 10.^(H1(1,2:end));
L  = H1(2,2:end);

gmID = diag(lookup(nch,'GM_ID','ID_W',JD,'L',L));
Avo  = diag(lookup(nch,'GM_GDS','ID_W',JD,'L',L)); 

[a b] = max(Avo);
A1 = a
L1 = L(b)
gmIDmax = gmID(b)
    
[c d] = max(gmID); 
gmIDmin = gmID(d)
A2 = Avo(d)
L2 = L(d)

CL = 1e-12;
gm = 2*pi*fu*CL;

ID1 = gm/gmIDmax
W1  = ID1/JD(b)
VGS1 = lookupVGS(nch,'ID_W',JD(b),'L',L1)

ID2 = gm/gmIDmin
W2  = ID2/JD(d)
VGS2 = lookupVGS(nch,'ID_W',JD(d),'L',L2)


% plot =======================
h1 = figure(1); 
subaxis(2,1,1, 'Spacing', 0.1, 'MarginBottom', 0.1, 'MarginTop', 0.03,...
    'MarginLeft', 0.15, 'MarginRight', 0.03)
plot(gmID,Avo,'k',gmID(b),a,'ko',gmID(d),Avo(d),'k*','linewidth',1); 
axis([0 25 0 50]); 
grid 
xlabel({'{\itg_m}/{\itI_D} (S/A)'; '(a)'});
ylabel('{\itA_v_o}');
    
subaxis(2,1,2);
plot(gmID,1e3*L,'k',gmID(b),1e3*L1,'ko',gmID(d),1e3*L2,'*k','linewidth',1)
axis([0 25 0 500]); 
grid 
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(b)'});
ylabel('{\itL}  (nm)');

%format_and_save(h1, 'Fig3_11', 'W', 5.3, 'H', 6)





