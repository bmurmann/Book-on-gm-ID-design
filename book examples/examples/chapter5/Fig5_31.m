% Ex. 5.6   input referred noise versus Cgg/(CS + CF) for various L
clearvars;
close all;
addpath ../../lib
load 65nch.mat

% Parameters
Csf = 1e-12;
ID = 1e-3;
W = 5:0.1:1000;
L  = [0.06 0.1 0.2 0.4];

% Compute relative noise level
Cgg = [W; W; W; W].*lookup(nch,'CGG_W', 'ID_W', ID./W, 'L', L);
gm = [W; W; W; W].*lookup(nch,'GM_W', 'ID_W', ID./W, 'L', L);
Noise = (Csf + Cgg).^2./gm;

% Normalize and find minima
Noise = Noise/min(min(Noise));
Cgg = Cgg/Csf;
[m, idx] = min(Noise');

h = figure;
plot(Cgg(1,:), Noise(1,:), 'k-', 'linewidth', 2);
hold on;
plot(Cgg(2,:), Noise(2,:), 'k-', 'linewidth', 1);
plot(Cgg(3,:), Noise(3,:), 'k--', 'linewidth', 1);
plot(Cgg(4,:), Noise(4,:), 'k-.', 'linewidth', 1);
plot([1/3 1/3+eps], [0 5], 'k:', 'linewidth', 2)
plot(Cgg(1,idx(1)), m(1), 'ko')
plot(Cgg(2,idx(2)), m(2), 'ko')
plot(Cgg(3,idx(3)), m(3), 'ko')
plot(Cgg(4,idx(4)), m(4), 'ko')
xlabel('{\itC_g_g}/({\itC_S} + {\itC_F)}');
ylabel('Noise (normalized to minimum)');
axis([0 0.7 0.8 3])
legend('{\itL} = 60 nm', '{\itL} = 100 nm', '{\itL} = 200 nm', '{\itL} = 400 nm', 'location', 'northeast');
grid;

%format_and_save(h, 'Fig5_31')

% Values at optima
Cgg_opt = diag(Cgg(:,idx))
gm_ID_opt = diag(gm(:,idx))/ID
wT_opt = diag(gm(:,idx)./Cgg(:,idx)/Csf)/2/pi
W_opt = W(idx)'


 

