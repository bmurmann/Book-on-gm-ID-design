% Fig. 6.26 Contours of the individual drain currents and transconductance efficiencies 
clearvars;
close all;
addpath ../../lib
load Fig6_26.mat;

% Specs
s.G = 2;
beta_max = 1/(1+s.G);

% Search range for main knobs
cltot_cc = linspace(0.2, 1.5, 100);
d.beta = beta_max*linspace(0.4, 0.95, 100)';

% Find design point with minimum current
IDtot = ID1+ID2;
[IDtot_opt, idx] = min(IDtot(:));
[idx1, idx2] = ind2sub(size(IDtot), idx);
cltot_cc_opt = cltot_cc(idx1)
beta_opt = d.beta(idx2);
beta_opt/beta_max

h1 = figure;
subaxis(2,2,1, 'Spacing', 0.14, 'MarginBottom', 0.1, 'MarginTop', 0.05, 'MarginLeft', 0.11, 'MarginRight', 0.02)
[c, h] = contour(d.beta/beta_max, cltot_cc, ID1*1e6, 0:50:300, 'k-');
clabel(c, h, 'fontsize', 8, 'LabelSpacing', 250); 
xlabel({'{\it\beta/\beta_m_a_x}'; '(a)'});
ylabel('{\itC_L_t_o_t}/{\itC_C}');
title('Contours of {\itI_D_1}  (\muA)', 'fontsize', 8', 'fontweight', 'normal');
text(beta_opt/beta_max, cltot_cc_opt, 'o')
text(beta_opt/beta_max-0.02, cltot_cc_opt+0.08, sprintf('%2.0f', ID1(idx1, idx2)*1e6), 'fontsize', 8')

subaxis(2,2,2)
[c, h] = contour(d.beta/beta_max, cltot_cc, gm_ID1, 10:4:30, 'k-');
clabel(c, h, 'fontsize', 8, 'LabelSpacing', 250); 
xlabel({'{\it\beta/\beta_m_a_x}'; '(b)'});
ylabel('{\itC_L_t_o_t}/{\itC_C}');
title('Contours of ({\itg_m}/{\itI_D})_1  (S/A)', 'fontsize', 8', 'fontweight', 'normal');
text(beta_opt/beta_max, cltot_cc_opt, 'o')
t = text(beta_opt/beta_max-0.07, cltot_cc_opt, sprintf('%2.1f', gm_ID1(idx1, idx2)), 'fontsize', 8');
set(t, 'BackgroundColor', 'white', 'margin', 1);

subaxis(2,2,3)
[c, h] = contour(d.beta/beta_max, cltot_cc, ID2*1e6, 0:50:1000, 'k-');
clabel(c, h, 'fontsize', 8, 'LabelSpacing', 250); 
xlabel({'{\it\beta/\beta_m_a_x}'; '(c)'});
ylabel('{\itC_L_t_o_t}/{\itC_C}');
title('Contours of {\itI_D_2}  (\muA)', 'fontsize', 8', 'fontweight', 'normal');
text(beta_opt/beta_max, cltot_cc_opt, 'o')
text(beta_opt/beta_max+0.03, cltot_cc_opt, sprintf('%2.0f', ID2(idx1, idx2)*1e6), 'fontsize', 8')

subaxis(2,2,4)
[c, h] = contour(d.beta/beta_max, cltot_cc, gm_ID2, 0:2:30, 'k-');
clabel(c, h, 'fontsize', 8, 'LabelSpacing', 250); 
xlabel({'{\it\beta/\beta_m_a_x}'; '(d)'});
ylabel('{\itC_L_t_o_t}/{\itC_C}');
title('Contours of ({\itg_m}/{\itI_D})_2  (S/A)', 'fontsize', 8', 'fontweight', 'normal');
text(beta_opt/beta_max, cltot_cc_opt, 'o')
text(beta_opt/beta_max, cltot_cc_opt-0.09, sprintf('%2.1f', gm_ID2(idx1, idx2)), 'fontsize', 8')

%format_and_save(h1, 'Fig6_26', 'W', 5.3, 'H', 6)
