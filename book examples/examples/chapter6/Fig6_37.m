% Fig 6.37 On-resistance of transmission gate vs. sizing ratio
clearvars;
close all;
addpath ../../lib
load 65nch.mat;
load 65pch.mat;

% parameters & compute
vdd = 1.2;
vinn = nch.VSB;
vinp = vdd - pch.VSB;
gdsn = diag(lookup(nch, 'GDS', 'VGS', vdd-vinn, 'VSB', vinn, 'VDS', 0));
gdsp = diag(lookup(pch, 'GDS', 'VGS', vinp, 'VSB', vdd-vinp, 'VDS', 0));

% interpolated curves
vinn_fine = 0:1e-3:max(vinn);
sn = spline(vinn, gdsn);
gdsn_fine = ppval(sn, vinn_fine)';
vinp_fine = vdd:-1e-3:min(vinp);
sp = spline(vinp, gdsp);
gdsp_fine = ppval(sp, vinp_fine)';

vin_fine = 0: vinn_fine(2)-vinn_fine(1):vdd;
n = length(vin_fine);
gdsn1 = [gdsn_fine; zeros(length(vin_fine)-length(gdsn_fine), 1)];
gdsp1 = [zeros(length(vin_fine)-length(gdsp_fine), 1); flipud(gdsp_fine)];

vin = 0: vinn(2)-vinn(1):vdd;
n = length(vin);
gdsn2 = [gdsn; zeros(length(vin)-length(gdsn), 1)];
gdsp2 = [zeros(length(vin)-length(gdsp), 1); flipud(gdsp)];

% Loop to find best sizing ratio
k = linspace(1,4, 300);
for j = 1:length(k);
    gdsp_k = k(j)*gdsp;
    sp = spline(vinp, gdsp_k);
    gdsp_fine = ppval(sp, vinp_fine)';
    gdsp1_k = [zeros(length(vin_fine)-length(gdsp_fine), 1); flipud(gdsp_fine)];
    ron = 1./(gdsp1_k+gdsn1);
    ratio(j) = max(ron)/min(ron);
end    

h = figure;
subaxis(1,2,1, 'Spacing', 0.1, 'MarginBottom', 0.19, 'MarginTop', 0.03, 'MarginLeft', 0.09, 'MarginRight', 0.02)
plot(k, ratio, 'k-', 'linewidth', 1)
xlabel({'Sizing ratio {\itk}'; '(a)'});
ylabel('{\itr_o_n_,_m_a_x} / {\itr_o_n_,_m_i_n}')
grid;

subaxis(1,2,2)
ron = 1./(gdsn1+2.6*gdsp1);
[y idx] = max(ron);
plot(vin_fine, ron, 'k-', vin_fine(idx), y, 'ko', 'linewidth', 1);
xlabel({'{\itV_I_N}  (V)'; '(b)'});
ylabel('\itr_o_n');
axis([0 vdd 0 450])
grid;
g = text(vin_fine(idx)-0.1, y+35, sprintf('r_o_n_,_m_a_x = %2.1f\\Omega', y), 'FontSize', 9);

%format_and_save(h, 'FIG6_37', 'W', 5.2);




