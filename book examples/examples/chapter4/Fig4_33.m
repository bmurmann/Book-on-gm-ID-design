% 4.3.2   standard deviation versus W
clearvars;
close all;
addpath ../../lib
load 65nch.mat

% Real device
ID = 100e-6;
L      = .06;
gm_ID  = (2:25)';
JD     = lookup(nch,'ID_W','GM_ID',gm_ID,'L',L);
W1 = ID./JD;
sigma1 = gm_ID*3.5e-3./sqrt(W1*L);

% EKV
y   = XTRACT(nch,L,.6,0,.8);  % xtract5(nch,L,VDS,VSb,R)
n   = y(2);
VT  = y(3);
ISu = y(4); % lookup table L = 10 micron
UT  = .026;
gm_IDmax = 1/(n*UT);
q = gm_IDmax./gm_ID - 1;
i = q.^2 + q; 
Issq = y(4)*.06/10;
W2 = ID./(i*ISu); 
sigma2 = gm_ID*3.5e-3./sqrt(W2*L);
%sigma2 = gm_IDmax*2./(sqrt(1+4*ID/Issq*L./W2)+1)*3.5e-3./sqrt(W2*L);

% Plot
h1 = figure; 
subaxis(2,1,1, 'Spacing', 0.14, 'MarginBottom', 0.14, 'MarginTop', 0.04, 'MarginLeft', 0.13, 'MarginRight', 0.03)
semilogx(W1,100*sigma1,'k-',W2,100*sigma2, 'k--', 'linewidth', 1);
xlabel({'{\itW}  (\mum)', '(a)'});
ylabel('stdev({\it\DeltaI_D}/{\itI_D_1})  (%)')
axis([0.2 200 0 10])
grid;

subaxis(2,1,2)
semilogx(W1,gm_ID,'k-',W2,gm_ID, 'k--', 'linewidth', 1);
xlabel({'{\itW}  (\mum)', '(b)'});
ylabel('{\itg_m}/{\itI_D}  (S/A)');
axis([0.2 200 0 25])
grid;

%format_and_save(h1, 'Fig4_33', 'H', 4.5); 
