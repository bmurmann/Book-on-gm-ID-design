% 4.3.2   standard deviation versus gm/ID
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

ID = 1000e-6;
W2 = ID./JD;
sigma2 = gm_ID*3.5e-3./sqrt(W2*L);

% Plot
h1 = figure(1); 
subaxis(2,1,1, 'Spacing', 0.14, 'MarginBottom', 0.14, 'MarginTop', 0.04, 'MarginLeft', 0.13, 'MarginRight', 0.03)
plot(gm_ID,100*sigma1,'k-', gm_ID,100*sigma2, 'k--', 'linewidth', 1);
xlabel({'{\itg_m}/{\itI_D}  (S/A)', '(a)'});
ylabel('stdev({\it\DeltaI_D}/{\itI_D_1})  (%)')
axis([3 25 0 10])
grid;

subaxis(2,1,2)
plot(gm_ID, W1,'k-', gm_ID, W2, 'k--', 'linewidth', 1);
xlabel({'{\itg_m}/{\itI_D}  (S/A)', '(b)'});
ylabel('{\itW}  (\mum)');
axis([3 25 0 200])
grid;

%format_and_save(h1, 'Fig4_34', 'H', 4.5); 
