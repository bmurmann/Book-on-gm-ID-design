% 4.3.3   temp coeff of 1/(gm/ID)
clearvars;
close all;
addpath ../../lib

% Load Spice data (27 and 28 degrees)
load('Fig4_37.mat')

% for x-axis
gm_id = gm27./id27;

% change in ID/gm for 1 degree temperature change
delta = id28./gm28 - id27./gm27; 

% expected TC for weak inversion
k = 1.3806488e-23;
qe = 1.602e-19;
n = qe/k/300.7/max(gm_id)
delta_wi = ones(1,length(gm27))*n*k/qe;

h = figure(1);
plot(gm_id, delta*1e3, 'k', gm_id, delta_wi*1e3, 'k--', 'linewidth',1);
xlabel('{\itg_m}/{\itI_D}  (S/A)');
ylabel('d/dT({\itI_D}/{\itg_m})  (mV/K)');
j = legend('SPICE simulation', '{\itn\cdotk}/{\itq_e}');
set(j, 'FontSize', 9);
axis([5 30 0 0.3]);
grid;

%format_and_save(h, 'Fig4_37');
