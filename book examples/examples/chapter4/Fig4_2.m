% 4.1.1   Plots of gamma factor
clearvars;
close all;
addpath ../../lib

load 65nch.mat;
load 65pch.mat;

% data =================
kB = 1.3806488e-23;
L = [0.06, 0.1, 0.2, 0.4];

% compute =====================
vgs = 0.2:25e-3:0.9;
for i=1:length(L)
    gm_id_n(:,i) = lookup(nch, 'GM_ID', 'VGS', vgs, 'L', L(i));
    gm_id_p(:,i) = lookup(pch, 'GM_ID', 'VGS', vgs, 'L', L(i));
    gamma_n(:,i) = lookup(nch, 'STH_GM', 'VGS', vgs, 'L', L(i))/4/kB/nch.TEMP;
    gamma_p(:,i) = lookup(pch, 'STH_GM', 'VGS', vgs, 'L', L(i))/4/kB/pch.TEMP;
end


% plot ===============================
h = figure;
subaxis(1,2,1, 'Spacing', 0.1, 'MarginBottom', 0.2, 'MarginTop', 0.03, 'MarginLeft', 0.1, 'MarginRight', 0.03)
plot(gm_id_n(:,1), gamma_n(:,1), 'k-', 'linewidth', 2)
hold on;
plot(gm_id_n(:,2), gamma_n(:,2), 'k-')
plot(gm_id_n(:,3), gamma_n(:,3), 'k--')
plot(gm_id_n(:,4), gamma_n(:,4), 'k-.')
legend('{\itL}= 60 nm', '{\itL}= 100 nm', '{\itL}= 200 nm', '{\itL}= 400 nm');
axis([3 30 0.5 1.1])
grid;
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(a)'})
ylabel('{\it\gamma_n}')
set(gca, 'ytick', 0.5:0.1:1.1);

subaxis(1,2,2);
plot(gm_id_p(:,1), gamma_p(:,1), 'k-', 'linewidth', 2)
hold on;
plot(gm_id_p(:,2), gamma_p(:,2), 'k-')
plot(gm_id_p(:,3), gamma_p(:,3), 'k--')
plot(gm_id_p(:,4), gamma_p(:,4), 'k-.')
legend('{\itL}= 60 nm', '{\itL}= 100 nm', '{\itL}= 200 nm', '{\itL}= 400 nm');
axis([3 30 0.5 1.1])
grid;
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(b)'})
ylabel('{\it\gamma_p}')
set(gca, 'ytick', 0.5:0.1:1.1);

%format_and_save(h, 'Fig4_2', 'W', 5.3, 'H', 3)



% =============================================== (Paul)
% gam for chapter 5  -->  LNA (L = 0.1 µm) 
%gm_ID2 = (7:1:12)';
%gam = interp1(gm_id_n(:,2),gamma_n(:,2),gm_ID2);

gm_ID2 = (8:2:20)';
gam = interp1(gm_id_n(:,2),gamma_n(:,2),gm_ID2);