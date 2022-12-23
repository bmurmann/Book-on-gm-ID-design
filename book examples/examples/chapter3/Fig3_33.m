% compare EKV to SPICE diff Amp
clear all
close all
addpath ../../lib
load 65nch.mat

% data ==================
gmID = 15
VDB  = 1.0;     % drain voltage with respect to the bulk
VGB  = .7;      %  gate voltage with respect to the bulk
L    = .06;

VGSo = lookupVGS(nch, 'GM_ID', gmID, 'VDB', VDB, 'VGB', VGB,'L',L)
VSo  = VGB-VGSo
JDo  = lookup(nch,'ID_W','GM_ID',gmID,'VSB',VSo,'VDS',VDB-VSo,'L',L)

%gmID = lookup(nch,'GM_ID','VGS',VGSo,'VSB',VSo,'VDS',VDB-VSo) % verif

VDS = VDB-VSo;
y = XTRACT(nch,L,VDS,VSo); 
n = y(2); JS = y(4);

UT  = .026;
Vg  = .02*(-10:10);      	% range input diff voltage  (V)
m   = (.05:.05:1.95); b = find(m==1);
io  = 2*JDo/JS;
i2  = .5*io*m; i1 = io - i2;
q2  = .5*(sqrt(1+4*i2)-1); 
q1  = .5*(sqrt(1+4*i1)-1);  
DVG = n*UT*(2*(q2-q1) + log(q2./q1));
I   = 2*interp1(DVG,i2,Vg,'spline')/io - 1 ; 
q  = q2(b);
cm = UT*(2*q - (q1+q2) + log(q./sqrt(q1.*q2)));
CM = interp1(DVG,cm,Vg,'spline');

% Load Spice data
load Fig3_33.mat

h = figure(1);
plot(Vg,I,'+k',Vg,VSo+CM,'xk', 'linewidth', 1.05); grid
hold;
plot(vid, iod/max(iod), 'k', vid, vs, 'k--', 'linewidth', 1); hold
xlabel('{\itv_i_d}  (V)'); 
axis([-0.3 0.3 -1 1])
legend('{\iti_o_d}/{\itI_0} EKV', '{\itv_S} EKV','{\iti_o_d}/{\itI_0} SPICE', '{\itv_S} SPICE', 'location', 'southeast')

%format_and_save(h, 'Fig3_33')

% size =====================
gm = 2*pi*1e9*1e-12;
ID = gm/gmID;
W  = ID/JDo

% error analysis ===========
Ierror = 1-I./interp1(vid,iod/max(iod),Vg)
1-(VSo+CM)./interp1(vid,vs,Vg)













