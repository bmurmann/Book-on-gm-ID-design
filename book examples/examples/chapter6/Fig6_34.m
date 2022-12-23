% Fig. 6.34 Current contours showing slewing region
clearvars;
close all;
addpath ../../lib
load 65nch.mat
load 65pch.mat

% Specifications
s.G = 2;
s.FO = 0.5;
s.fu1 = 220e6;
s.fp2 = 6*s.fu1;
s.vod_noise = 400e-6;
s.L0 = 50;
beta_max = 1/(1+s.G);

% Design decisions and estimates
d.L1 = 0.15; d.L2 = 0.2; d.L3 = 0.2; d.L4 = 0.15;
d.gam1 = 0.8; d.gam2 = 0.8; d.gam3 = 0.8; d.gam4 = 0.8;
d.gm3_gm1 = 1; d.gm4_gm2 = 0.5;
d.cgs2_cc = 0.5;
d.rself1 = 0;
d.rself2 = 0;

% Search range for main knobs
cltot_cc = linspace(0.2, 1.5, 30);
d.beta = beta_max*linspace(0.4, 0.95, 30)';

for j=1:length(cltot_cc)
        d.cltot_cc = cltot_cc(j);
        [m1, m2, m3, m4, p] = two_stage(pch, nch, nch, pch, s, d);
        ID1(j,:) = m1.id;
        ID2(j,:) = m2.id;
        gm_ID1(j,:) = m1.gm_id;
        gm_ID2(j,:) = m2.gm_id;
        Cc(j,:) = p.cc;
        CLtot(j,:) = p.cltot;
end

% Find design point with minimum current
IDtot = ID1+ID2;
[IDtot_opt, idx] = min(IDtot(:));
[idx1, idx2] = ind2sub(size(IDtot), idx);
cltot_cc_opt = cltot_cc(idx1)
beta_opt = d.beta(idx2);
beta_opt/beta_max

h1 = figure;
[c, h] = contour(d.beta/beta_max, cltot_cc, IDtot*1e6, 0:50:1000, 'k-');
clabel(c, h, 'fontsize', 9, 'LabelSpacing', 250); 
xlabel('{\it\beta/\beta_m_a_x}');
ylabel('{\itC_L_t_o_t}/{\itC_C}');
title('Contours of {\itI_D_1}+{\itI_D_2}  (\muA)', 'fontsize', 9', 'fontweight', 'normal');
text(beta_opt/beta_max, cltot_cc_opt, 'o')
text(beta_opt/beta_max, cltot_cc_opt+0.05, sprintf('%2.0f', IDtot_opt*1e6), 'fontsize', 9')
hold on;

indicator = ID2 < ID1.*(1+CLtot./Cc);
for i = 1:length(d.beta)
    for j = 1:length(cltot_cc)
        if(indicator(j,i))
            plot(gca, d.beta(i)/beta_max, cltot_cc(j), 'x', 'color', [0.6 0.6 0.6], 'linewidth', 1.01)
        end
    end
end
        
%format_and_save(h1, 'Fig6_34')

