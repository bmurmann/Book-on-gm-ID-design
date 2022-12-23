% Fig. 6.25 Drain current contours of Ex. 6.7
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
end

% Save data for Fig. 6.26
%save('Fig6_26.mat', 'ID1', 'ID2', 'gm_ID1', 'gm_ID2');

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

%format_and_save(h1, 'Fig6_25')

% Look at all parameters in the optimum point
d.beta = beta_opt;
d.cltot_cc = cltot_cc_opt;
[m1, m2, m3, m4, p] = two_stage(pch, nch, nch, pch, s, d);

% Iterate
rself1 = zeros(1, 10);
rself2 = zeros(1, 10);
for i = 1:length(rself1)
    for j=1:length(cltot_cc)
        d.cltot_cc = cltot_cc(j);
        d.rself1 = rself1(i);
        d.rself2 = rself2(i);
 
        [m1, m2, m3, m4, p] = two_stage(pch, nch, nch, pch, s, d);
        IDtot(j,:) = m1.id + m2.id;
        rself1_out(j,:) = p.rself1;
        rself2_out(j,:) = p.rself2;
    end
 
    % Find optimum and evaluate self loading at optimum
    [IDtot_opt, idx] = min(IDtot(:));
    [idx1, idx2] = ind2sub(size(IDtot), idx);
    rself1(i+1) = rself1_out(idx1, idx2);
    rself2(i+1) = rself2_out(idx1, idx2);
end

% Save data for Fig. 6.27
save('Fig6_27.mat', 'rself1', 'rself2');
