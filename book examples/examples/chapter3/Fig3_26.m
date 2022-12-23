% Example 3.7 and 3.8
clear all
close all
addpath ../../lib
load 65nch.mat
load 65pch.mat

% data ===========
VDD = 1.2;
C  = 1e-12;
fT = 1e10;
FO = 10;

gm_ID2 = 10;     % max output dynamic range
L2 = 0.5;

% Example 3-7=====================================================
% compute gain ========
VDS = .6;     	
LL  = .06: .01: .2;

gm_ID1  = lookup(nch,'GM_ID','GM_CGG',2*pi*fT,'VDS',VDS,'L',LL);
gds_ID1 = lookup(nch,'GDS_ID','GM_CGG',2*pi*fT,'VDS',VDS,'L',LL);
gds_ID2 = lookup(pch,'GDS_ID','GM_ID',gm_ID2,'VDS',VDD - VDS,'L',L2);

% maximize gain =========
Av = gm_ID1./(gds_ID1 + gds_ID2);
[a b] = max(Av);   % find L1 making Av max
L1  = LL(b)
Avo = Av(b)

% de-normalize and introduce parasitc cap ===========
JDn    = lookup(nch,'ID_W','GM_ID',gm_ID1(b),'VDS',VDS,'L',L1);
Cdd_Wn = lookup(nch,'CDD_W','GM_ID',gm_ID1(b),'VDS',VDS,'L',L1);
JDp    = lookup(pch,'ID_W','GM_ID',gm_ID2,'VDS',VDD - VDS,'L',L2);
Cdd_Wp = lookup(pch,'CDD_W','GM_ID',gm_ID2,'VDS',VDD - VDS,'L',L2);

Cdd = 0;
for k = 1:5,
    gm = 2*pi*fT/FO*(C+Cdd);
    ID = gm/gm_ID1(b);
    Wn = ID/JDn;
    Wp = ID/JDp;
    Cdd = Wn*Cdd_Wn + Wp*Cdd_Wp;
end

% results ==============
L1
Wn
Wp
ID
    

VGS1 = lookupVGS(nch,'GM_ID',gm_ID1(b),'VDS',VDS,'L',L1)
VGS2 = lookupVGS(pch,'GM_ID',gm_ID2,'VDS',VDD - VDS,'L',L2)
fu = gm/(2*pi*(C+Cdd))
Cdd


% Example 3-8 ===================================================
VDS1 = .05: .01: 1.15;
ID2 = Wp*lookup(pch,'ID_W','VGS',VGS2,'VDS',VDD-VDS1,'L',L2);
ID1 = Wn*lookup(nch,'ID_W','VGS',nch.VGS,'VDS',VDS1,'L',L1)';
for m = 1:length(VDS1),
	 UGS1(:,m) = interp1(ID1(m,:),nch.VGS,ID2(m),'pchip');
end

% plot ===================
UGS1o = interp1(VDS1,UGS1,VDD/2)
h = figure(1);
plot(UGS1,VDS1,'color', 0.7*[1 1 1], 'linewidth',3); 
hold on;
plot(UGS1o,VDD/2,'ko');
axis([0.4 0.65 0 VDD]); 
%grid;
xlabel('{\itv_I_N}   (V)')
ylabel('{\itv_O_U_T}   (V)')

% Add Spice results
load('Fig3_26.mat')
plot(vin_spice, vout_spice,'k')
legend('Matlab', 'OP point', 'Spice', 'location', 'NorthEast');

% mark output swing
g = line([0 1.2], [1 1], 'color', 'k', 'linestyle', '--');
g = line([0 1.2], [0.2 0.2], 'color', 'k', 'linestyle', '--');
g = text(0.41, 0.93, ['{\itV_D_D}' char(8211) '{\itV_D_s_a_t_2}']);
set(g, 'fontsize', 9);
g = text(0.41, 0.13, '{\itV_D_s_a_t_1}');
set(g, 'fontsize', 9);

%format_and_save(h, 'Fig3_26')

% derive gain frim d(VDS1)/d(UGS1) ============
A = diff(VDS1)./diff(UGS1);
gain = interp1((VDS1(1:end-1)+VDS1(2:end))/2,A,.6)


% ideal = (UGS1-VGS1)*gain + VDD/2;
% figure(2)
% plot(VDS1, (VDS1-ideal), 'r-')
% axis([0 1.2 -0.2 0.2])
% g = line([0.2 0.2], [-0.2 0.2], 'color', 'k', 'linestyle', '--');
% g = line([1 1], [-0.2 0.2], 'color', 'k', 'linestyle', '--');







