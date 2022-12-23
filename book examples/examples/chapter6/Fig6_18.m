% Fig. 6.18 Folded cascode OTA optimization
clearvars;
close all;
addpath ../../lib
load 65nch.mat
load 65pch.mat

% Compute required unity gain frequency
s.ts = 5e-9;
s.ed = 0.1e-2;
s.fu1 = 1/2/pi * log(1/s.ed)/s.ts;
fp2 = 2e9;
fp2/s.fu1;

% Other design specifications
s.vod_noise = 400e-6;
s.FO = 0.5;
s.G = 2;
beta_max = 1/(1+s.G);

% Design choices and constants
d.gamma = 0.7;
d.Lcas = 0.4;
d.gm_IDcas = 15;

% Parameter setup
L1 = [0.1 0.2 0.3 0.4];
d.cself = 0;
d.gm_ID1 = (3:0.01:27)';
d.beta = beta_max*(0.2:0.001:1)';

% Channel length sweep
for i = 1: length(L1)
    d.L1 = L1(i);
    [m1(i) p(i)] = folded_cascode(pch, nch, s, d);
end

% Plot
h = figure;
subaxis(2,1,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.12, 'MarginRight', 0.03)
plot(m1(1).gm_ID, m1(1).ID*1e3, 'k', 'linewidth', 2)
hold on;
plot(m1(2).gm_ID, m1(2).ID*1e3, 'k')
plot(m1(3).gm_ID, m1(3).ID*1e3, 'k--')
plot(m1(4).gm_ID, m1(4).ID*1e3, 'k-.')
xlabel({'({\itg_m}/{\itI_D})_1  (S/A)'; '(a)'});
ylabel('{\itI_D_1}  (mA)');
axis([5 27 0 1.2])
leg = legend('{\itL} = 100nm', '{\itL} = 200nm', '{\itL} = 300nm', '{\itL} = 400nm', 'location', 'north');
pos = get(leg,'Position');
set(leg,'Position', [pos(1)-0.13 pos(2) pos(3) pos(4)])

subaxis(2,1,2)
plot(m1(1).gm_ID, p(1).cself./p(1).cltot, 'k', 'linewidth', 2)
hold on;
plot(m1(2).gm_ID, p(2).cself./p(2).cltot, 'k')
plot(m1(3).gm_ID, p(3).cself./p(3).cltot, 'k--')
plot(m1(4).gm_ID, p(4).cself./p(4).cltot, 'k-.')
xlabel({'({\itg_m}/{\itI_D})_1  (S/A)'; '(b)'});
ylabel('{\itr_s_e_l_f}');
axis([3 27 0 0.7])

%format_and_save(h, 'Fig6_18', 'H', 5);
