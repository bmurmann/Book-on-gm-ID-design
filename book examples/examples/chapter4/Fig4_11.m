% Example 4.3   flicker noise corner versus gm/ID
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

L = [0.06, 0.1, 0.2, 0.4];
vgs = 0.2:25e-3:0.9;
for i=1:length(L)
    gm_id_n(:,i) = lookup(nch, 'GM_ID', 'VGS', vgs, 'L', L(i));
    fco(:,i) = lookup(nch, 'SFL_STH', 'VGS', vgs, 'L', L(i));
end

h = figure;
semilogy(gm_id_n(:,1), fco(:,1), 'k-', 'linewidth', 2)
hold on;
semilogy(gm_id_n(:,2), fco(:,2), 'k-')
semilogy(gm_id_n(:,3), fco(:,3), 'k--')
semilogy(gm_id_n(:,4), fco(:,4), 'k-.')
legend('{\itL}= 60 nm', '{\itL}= 100 nm', '{\itL}= 200 nm', '{\itL}= 400 nm');
axis([3 32 1e3 1e8])
grid;
xlabel('{\itg_m}/{\itI_D}  (S/A)')
ylabel('{\itf_c_o}  (Hz)')
set(gca, 'YMinorGrid', 'off');

%format_and_save(h, 'Fig4_11')

