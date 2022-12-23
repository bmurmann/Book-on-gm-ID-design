% Fig. 6.7 Normalized drain current versus feedback factor
clearvars;
close all;
addpath ../../lib
load 65nch.mat

% Parameters
wu = 2*pi*1e9;
L = 0.1;
G = 2;
FO = [0.5 1 2 4];
gm_ID = 2:0.1:29;
wTi = lookup(nch,'GM_CGS', 'GM_ID', gm_ID, 'L', L);
beta = NaN(length(FO), length(gm_ID)); 
K = NaN(length(FO), length(gm_ID)); 

% Compute K factor
for i = 1: length(FO)
    beta(i,:) = (1- (1+FO(i)*G).*wu./wTi) ./ (1+G -(wu./wTi));
    beta(beta<0) = NaN;
    K(i,:) = 1./beta(i,:).^2./gm_ID;
end

% Normalize and find minimum current
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
plot(beta(1,:)/beta_max, K(1,:), 'k-', 'linewidth', 2);
hold on;
plot(beta(2,:)/beta_max, K(2,:), 'k-');
plot(beta(3,:)/beta_max, K(3,:), 'k--');
plot(beta(4,:)/beta_max, K(4,:), 'k-.');
plot([0.75 0.75], [0 10], 'color', 0.7*[1 1 1], 'linewidth', 2);
plot(beta_opt_max(1), Kmin(1), 'ko');
plot(beta_opt_max(2), Kmin(2), 'ko');
plot(beta_opt_max(3), Kmin(3), 'ko');
plot(beta_opt_max(4), Kmin(4), 'ko');
xlabel('{\it\beta}/{\it\beta_m_a_x}');
ylabel('{\itK} (normalized to minimum)');
axis([0.2 1 0 8])
grid;
legend('{\itFO} = 0.5', '{\itFO} = 1', '{\itFO} = 2', '{\itFO} = 4', 'location', 'southwest');

%format_and_save(h, 'Fig6_7')



 

