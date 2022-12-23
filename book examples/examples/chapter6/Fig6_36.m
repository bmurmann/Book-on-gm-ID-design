% Fig 6.36 On-resistance of transmission gate
clear vars;
close all;
addpath ../../lib
load 65nch.mat;
load 65pch.mat;

% paremeters & compute
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

h = figure(1);
semilogy(vin_fine, 1./gdsn1, 'k-', vin_fine, 1./gdsp1, 'k--')
hold on;
plot(vin_fine, 1./(gdsn1+gdsp1), 'k-', 'linewidth', 2);
plot(vin, 1./gdsn2, 'ko', vin, 1./gdsp2, 'ko', vin, 1./(gdsn2+gdsp2), 'ko');
axis([0 vdd 10 3e3])
xlabel('{\itV_I_N}  (V)')
ylabel('{\itr_o_n}  (\Omega)')
grid;
rn = min(1./gdsn2);
rp = min(1./gdsp2);
text(0.02, rn*0.8, sprintf('%2.0f', rn), 'fontsize', 9);
text(1.1, rp*0.8, sprintf('%2.0f', rp), 'fontsize', 9);

%format_and_save(h, 'Fig6_36');
