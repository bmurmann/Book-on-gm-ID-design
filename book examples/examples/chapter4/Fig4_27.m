% 4.2.3    HD2 and HD3 versus gm/ID
clearvars;
close all;
addpath ../../lib

% Load Spice data
load('Fig4_27.mat')

% HD calculations
hd2_db_100n = 20*log10(vo_100n(3,:)./vo_100n(2,:));
hd3_db_100n = 20*log10(vo_100n(4,:)./vo_100n(2,:));
hd2_db_100n_cas = 20*log10(vo_100n_cas(3,:)./vo_100n_cas(2,:));
hd3_db_100n_cas = 20*log10(vo_100n_cas(4,:)./vo_100n_cas(2,:));

hd2_db_60n = 20*log10(vo_60n(3,:)./vo_60n(2,:));
hd3_db_60n = 20*log10(vo_60n(4,:)./vo_60n(2,:));
hd2_db_60n_cas = 20*log10(vo_60n_cas(3,:)./vo_60n_cas(2,:));
hd3_db_60n_cas = 20*log10(vo_60n_cas(4,:)./vo_60n_cas(2,:));

% Plot
h = figure;
subaxis(1,2,1, 'Spacing', 0.12, 'MarginBottom', 0.2, 'MarginTop', 0.06, 'MarginLeft', 0.1, 'MarginRight', 0.03)
plot(gm_id_100n, hd2_db_100n, 'k', gm_id_100n, hd3_db_100n, 'k', 'linewidth',2);
g = title('{\itL} = 100 nm');
set(g, 'fontsize', 9, 'fontweight', 'normal');
grid;
text(23, -34, 'HD_2', 'fontsize', 9);
text(23, -68, 'HD_3', 'fontsize', 9);
xlabel({'{\itg_m}/{\itI_D}  (S/A)', '(a)'}); 
ylabel('Harmonic distortion (dB)');
axis([5 28 -110 -20]);
hold on;
k =10;
plot(gm_id_100n_cas(1:end-k), hd2_db_100n_cas(1:end-k), 'k', gm_id_100n_cas(1:end-k), hd3_db_100n_cas(1:end-k), 'k', 'linewidth',1);

subaxis(1,2,2)
plot(gm_id_60n, hd2_db_60n, 'k', gm_id_60n, hd3_db_60n, 'k', 'linewidth',2);
g = title('{\itL} = 60 nm');
set(g, 'fontsize', 9, 'fontweight', 'normal');
grid;
text(23, -34, 'HD_2', 'fontsize', 9);
text(23, -68, 'HD_3', 'fontsize', 9);
axis([5 28 -110 -20]);
xlabel({'{\itg_m}/{\itI_D}  (S/A)', '(b)'}); 
ylabel('Harmonic distortion (dB)');
hold on;
k =10;
plot(gm_id_60n_cas(1:end-k), hd2_db_60n_cas(1:end-k), 'k', gm_id_60n_cas(1:end-k), hd3_db_60n_cas(1:end-k), 'k', 'linewidth',1);

%format_and_save(h, 'Fig4_27', 'W', 5.3);


