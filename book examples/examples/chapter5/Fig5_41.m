% Ex. 5.11 simulated chrage amp bandwidth and noise across corners
clearvars;
close all;
addpath ../../lib

% Load Spice data
load('Fig5_41.mat')

% Plot
h = figure;
subaxis(2,1,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.02, 'MarginLeft', 0.13, 'MarginRight', 0.02)

for i = 1:3;
    magdb = 20*log10(vo(i,:));
    gaindb_sim = max(magdb);
    fc(i) = interp1(magdb, f(i,:), gaindb_sim-3, 'spline');
    magdb_fc(i) = interp1(f(i,:), magdb, fc(i), 'spline');
    noise_at_fc(i) = interp1(f1(i,:), noise(i,:), 3e9, 'spline');
    
    subaxis(2,1,1)
    semilogx(f(i,:), magdb,'k-')
    hold on;

    subaxis(2,1,2)
    loglog(f1(i,:), noise(i,:)/1e-12,'k-')
    hold on;
end

subaxis(2,1,1)
semilogx(fc, magdb_fc, 'ko')
xlabel({'Frequency (Hz)', '(a)'})
ylabel('|{\itv_o}/{\itv_t_e_s_t}|  (dB)')
axis([1e8 2e10 -20 -3]);
grid;
set(gca,'XMinorGrid', 'off');
legend('Slow, hot', 'Nom.', 'Fast, cold', 'location', 'southwest');
g = get(gca, 'children');
set(g(3), 'linewidth', 2);
set(g(2), 'linestyle', '--');

adc = max(magdb);
fc_spec = 3e9;
hl=line([fc_spec-1.5e9 fc_spec], [adc-3 adc-3]);
set(hl, 'color', 'k', 'linewidth', 2);
hl=line([fc_spec fc_spec], [adc-3 adc-6]);
set(hl, 'color', 'k', 'linewidth', 2);
ht=text(1.4e9, adc-4.5, 'Spec');
set(ht, 'fontsize', 8);

subaxis(2,1,2)
loglog(3e9*[1 1 1], noise_at_fc./1e-12, 'ko')
xlabel({'Frequency (Hz)', '(b)'})
ylabel('Input noise (pA/rt-Hz)')
grid;
set(gca,'XMinorGrid', 'off');
set(gca,'YMinorGrid', 'off');
axis([1e8 2e10 1 300]);
g = get(gca, 'children');
set(g(3), 'linewidth', 2);
set(g(2), 'linestyle', '--');

hl=line([fc_spec-1.5e9 fc_spec], [50 50]);
set(hl, 'color', 'k', 'linewidth', 2);
hl=line([fc_spec fc_spec], [50 120]);
set(hl, 'color', 'k', 'linewidth', 2);
ht=text(1.4e9, 85, 'Spec');
set(ht, 'fontsize', 8);

%format_and_save(h, 'Fig5_41', 'H', 4.5)
