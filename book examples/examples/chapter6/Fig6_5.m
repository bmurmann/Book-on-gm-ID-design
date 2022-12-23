% Fig. 6.5 OTA feedback factor optimization (fixed gain)
clearvars;
close all;
addpath ../../lib
load 65nch.mat

% Parameters
wu = 2*pi*1e9;
L = 0.1;
G = 2;
FO = [0.5 1 2 4];
gm_ID = 3:0.1:29;
wTi = lookup(nch,'GM_CGS', 'GM_ID', gm_ID, 'L', L);
beta = NaN(length(FO), length(gm_ID)); 
K = NaN(length(FO), length(gm_ID)); 

% Compute K factor
for i = 1: length(FO)
    beta(i,:) = (1- (1+FO(i)*G).*wu./wTi) ./ (1+G -(wu./wTi));
    beta(beta<0) = NaN;
    K(i,:) = 1./beta(i,:).^2./gm_ID;
end

% % Normalize and find minimum current
K = K/min(min(K));
[Kmin, idx] = min(K');

% Parameter values at minimum current
gm_ID_opt = gm_ID(idx)
fT_opt = wTi(idx)/2/pi
beta_opt = diag(beta(:,idx));
beta_max = 1./(1+G);
beta_opt_max = beta_opt./beta_max
cgs_cs_cf = 1./beta_opt_max -1

h = figure;
subaxis(2,1,1, 'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.03, 'MarginLeft', 0.12, 'MarginRight', 0.03)
plot(gm_ID, beta(1,:)/beta_max, 'k-', 'linewidth', 2);
hold on;
plot(gm_ID, beta(2,:)/beta_max, 'k-');
plot(gm_ID, beta(3,:)/beta_max, 'k--');
plot(gm_ID, beta(4,:)/beta_max, 'k-.');
plot(gm_ID(idx(1)), beta_opt_max(1), 'ko');
plot(gm_ID(idx(2)), beta_opt_max(2), 'ko');
plot(gm_ID(idx(3)), beta_opt_max(3), 'ko');
plot(gm_ID(idx(4)), beta_opt_max(4), 'ko');
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(a)'})
ylabel('{\it\beta}/{\it\beta_m_a_x}');
axis([min(gm_ID) max(gm_ID)+1 0 1])
legend('{\itFO} = 0.5', '{\itFO} = 1', '{\itFO} = 2', '{\itFO} = 4', 'location', 'southwest');
grid;

subaxis(2,1,2);
plot(gm_ID, K(1,:), 'k-', 'linewidth', 2);
hold on;
plot(gm_ID, K(2,:), 'k-');
plot(gm_ID, K(3,:), 'k--');
plot(gm_ID, K(4,:), 'k-.');
plot(gm_ID(idx(1)), Kmin(1), 'ko');
plot(gm_ID(idx(2)), Kmin(2), 'ko');
plot(gm_ID(idx(3)), Kmin(3), 'ko');
plot(gm_ID(idx(4)), Kmin(4), 'ko');
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(b)'})
ylabel('{\itK} (normalized to minimum)');
axis([min(gm_ID) max(gm_ID)+1 0 10])
grid;

%format_and_save(h, 'Fig6_5', 'H', 5)



 

