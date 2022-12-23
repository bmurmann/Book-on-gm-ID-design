% Fig. 6.17 Low-frequency loop gain plot of Example 6.4
clearvars;
close all;
addpath ../../lib
load 65nch.mat
load 65pch.mat

% Design specifications and assumptions
G = 2;
beta_max = 1/(1+G);
beta = 0.75*beta_max;   % first-order optimum
kappa = 0.7;            % conservative estimate
gm_ID = 15;

% Channel length sweep
L = linspace(0.06, 1, 100);
gm_gds2 = lookup(nch, 'GM_GDS', 'GM_ID', gm_ID, 'VDS', 0.2, 'VSB', 0, 'L', L);
gm_gds3 = lookup(nch, 'GM_GDS', 'GM_ID', gm_ID, 'VDS', 0.4, 'VSB', 0.2, 'L', L);
gm_gds4 = lookup(pch, 'GM_GDS', 'GM_ID', gm_ID, 'VDS', 0.4, 'VSB', 0.2, 'L', L);
gm_gds5 = lookup(pch, 'GM_GDS', 'GM_ID', gm_ID, 'VDS', 0.2, 'VSB', 0, 'L', L);

% Loop gain calculation
L0 = zeros(length(L), length(L));
for j = 1:length(L)
    L0(j,:) = beta*kappa./( 1./(1+gm_gds5)./gm_gds4 + 1./(1+gm_gds2(j)/3)./gm_gds3(j) );
end 

g = figure;
[C,h] = contour(L, L, L0);
set(h, 'linecolor', 'k');
clabel(C,h, 'fontsize', 9);
xlabel('{\itL_2_,_3} (\mum)');
ylabel('{\itL_4_,_5} (\mum)');
hold on;
plot(0.4, 0.4, 'k+', 'markersize', 9, 'linewidth', 2);

%format_and_save(g, 'Fig6_17');

% Chosen length
L23 = 0.4;

% Resulting device parameters
gmb_gm3 = lookup(nch, 'GMB_GM', 'GM_ID', gm_ID, 'VDS', 0.4, 'VSB', 0.2, 'L', L23);
gm_css3 = lookup(nch, 'GM_CSS', 'GM_ID', gm_ID, 'VDS', 0.4, 'VSB', 0.2, 'L', L23);
cdd_css3 = lookup(nch, 'CDD_CSS', 'GM_ID', gm_ID, 'VDS', 0.4, 'VSB', 0.2, 'L', L23);
cdd_w3 = lookup(nch, 'CDD_CSS', 'GM_ID', gm_ID, 'VDS', 0.4, 'VSB', 0.2, 'L', L23);
cdd_w2 = lookup(nch, 'CDD_CSS', 'GM_ID', gm_ID, 'VDS', 0.2, 'L', L23);

% Nondominant pole frequency
fp2 = 1/2/pi * gm_css3 * (1+gmb_gm3)/(1 + 2*cdd_css3*2*(cdd_w2/cdd_w3))
