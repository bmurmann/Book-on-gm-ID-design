% Ex. 5.4   LNA NF versus gm/ID for various ID2/ID1
clear all
close all
addpath ../../lib
load 65nch.mat

% data ==========================
VDD  = 1.2;   
RS   = 50;
L  = .1;
gm_ID2 = (8:2:20)';  	% param      
VR = .4;                % identical volt drops across load resistors

% Sizing LNA (except ID2 and W2) =======================

% 1) M2 --> A2, VGS2 and ID1 + R1 and RB ========
z2 = length(gm_ID2);
VDS2   = VDD - VR;
VGS2   = lookupVGS(nch,'GM_ID',gm_ID2,'VDS',VDS2,'L',L);
JD2    = lookup(nch,'ID_W','GM_ID',gm_ID2,'VDS',VDS2,'L',L);
gds_ID2 = lookup(nch,'GDS_ID','GM_ID',gm_ID2,'VDS',VDS2,'L',L);
Cgg_W2 = lookup(nch,'CGG_W','GM_ID',gm_ID2,'VDS',VDS2,'L',L);


A2  = gm_ID2./(gds_ID2 + 1/VR);
Av  =2*A2;
ID1 = 1./(RS*(A2/VR + 1./VGS2));  
R1  = VR./ID1;
RB  = R1./(R1/RS - A2);     % (R1/A1) // RB = RS

% 2) M1 --> A1 ========
VDS1   = VDD - VR - VGS2;
for k = 1:length(gm_ID2),
    gm_W1(:,k)  = lookup(nch,'GM_W','VDS',VDS1(k),'VSB',VGS2(k),'L',L);
    gmb_W1(:,k) = lookup(nch,'GMB_W','VDS', VDS1(k),'VSB',VGS2(k),'L',L);
    gds_W1(:,k) = lookup(nch,'GDS_W','VDS', VDS1(k),'VSB',VGS2(k),'L',L);
    JD1(:,k) = lookup(nch,'ID_W','VDS',VDS1(k),'VSB',VGS2(k),'L',L);
    CSS1_W(:,k) = lookup(nch,'CSS_W','VDS',VDS1(k),'VSB',VGS2(k),'L',L);

end
A1   = (gm_W1 + gmb_W1 + gds_W1)./(gds_W1 + JD1/VR); % [nch.VGS  gm_ID2]

% ======= equalize gains =================
for k = 1:length(gm_ID2)
    y(k,:) = interp1(A1(:,k),[nch.VGS  JD1(:,k)  gm_W1(:,k)...
        CSS1_W(:,k)],A2(k));
end

VGS1 = y(:,1);      % column vectors like gm/ID2
W1   = ID1./y(:,2);
gm1  = W1.*y(:,3);
gm_ID1 = gm1./ID1;
CSS1 = W1.*y(:,4);


% ================= EXAMPLE 5.4  -->  NF ========================
z1  = 10; m  = logspace(0,log10(15),z1);   
ID2 = m(ones(z2,1),:).*ID1(:,ones(1,z1)); % ID2 = m*ID1   [gm_ID2 ID2/ID1]
W2  = ID2./JD2(:,ones(1,z1))

% ==== interpolated gamma_n from Figure 4.2 versus (gm/ID)2 for L = 100 nm 
gam = [0.7449  0.7317    0.7230    0.7144    0.7043    0.6924    0.6787]';

% NF ===============
for k = 1:z1,
    R2   = VR./ID2(:,k);
    gm2  = gm_ID2.*ID2(:,k);
    gds2 = gds_ID2.*ID2(:,k);

    Denom = .25*RS * Av.^2; 
    F1 = gam.*gm1.*(R1 - Av*RS/2).^2./Denom;
    F2 = gam.*gm2.*(R2./(1+R2.*gds2)).^2./Denom;
    F3 = (R1 + R2)./Denom;
    F4 = RS./RB;        
    F  = 1 + F1 + F2 + F3 + F4;
    NF(:,k) = 10*log10(F);  % vert gm_ID2,  horiz ID2/ID1
end

% plot ===================
NFo = 2.5;
h1 = figure(1);
plot(m,NF,'k','linewidth',1); hold
plot([0 15],NFo*[1 1],'k--','linewidth',1); hold
axis([0 15 0 5]); 
grid;
xlabel('{\itI_D_2}/{\itI_D_1}');
ylabel('{\itNF}  (dB)');
text(7,3.1,{'({\itg_m}/{\itI_D})_2';' 8 S/A'}, 'fontsize', 9);
text(5,1.3,'20 S/A', 'fontsize', 9);

%format_and_save(h1, 'Fig5_20')
