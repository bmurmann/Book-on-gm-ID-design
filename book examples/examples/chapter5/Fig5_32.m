% Ex. 5.7   relative drain current versus gm/ID
clear all
close all
addpath ../../lib
load 65nch.mat

% Parameters
wc = 2*pi*3e9;
L = [0.06 0.1 0.2 0.4];
FO = 3;

% Sweep gm/ID and compute K factor
gm_ID = 5:0.1:25;
wT = lookup(nch,'GM_CGG', 'GM_ID', gm_ID, 'L', L);
K = (1./(1-wc./wT/FO)).^2 .* repmat(1./gm_ID', 1, 4)';

% Filter out points with negative value of 1-wc./wT)
[idx1, idx2] = find(wc./wT/FO >= 1);
K(idx1, idx2) = NaN;

% % Normalize and find minima
K = K/min(min(K));
[m, idx] = min(K');

h = figure;
plot(gm_ID, K(1,:), 'k-', 'linewidth', 2);
hold on;
plot(gm_ID, K(2,:), 'k-');
plot(gm_ID, K(3,:), 'k--');
plot(gm_ID, K(4,:), 'k-.');
plot(gm_ID(idx(1)), m(1), 'ko');
plot(gm_ID(idx(2)), m(2), 'ko');
plot(gm_ID(idx(3)), m(3), 'ko');
plot(gm_ID(idx(4)), m(4), 'ko');
xlabel('{\itg_m}/{\itI_D}  (S/A)');
ylabel('Current, ({\itK} factor, normalized to minimum)');
axis([min(gm_ID) max(gm_ID) 0 5])
legend('{\itL} = 60 nm', '{\itL} = 100 nm', '{\itL} = 200 nm', '{\itL} = 400 nm', 'location', 'northeast');
grid;

% format_and_save(h, 'Fig5_32')

% Values at optima
gm_ID_opt = gm_ID(:,idx)'
fT_opt = diag(wT(:,idx)/2/pi)
Cgg_rel_opt = 1./ (FO*fT_opt/(wc/2/pi) -1)


 

