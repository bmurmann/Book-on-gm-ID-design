% Figure 6.13 Plot for Example 6.3
clearvars;
close all;
addpath ../../lib
load 65nch.mat

% Constants and design specifications
kB = 1.3806488e-23;
T = nch.TEMP;
gamma = 0.7;
vod_noise = 100e-6;
G = 2;
FO = 1;
CL_CFtot = G*FO;
ed = 0.1e-2;
ts = 1.1e-9;
beta_max = 1/(1+G);
L = 0.1;

% Search parameters
vodfinal = [0.01 0.8 1.6];
gm_ID = (5:0.01:28)';
beta = (0.25*beta_max:0.001:beta_max)';
beta_rel = beta/beta_max;

% Initialize result arrays
ID_valid = NaN(length(beta), length(vodfinal));
gm_ID_valid = NaN(length(beta), length(vodfinal));
X_valid = NaN(length(beta), length(vodfinal));

% pre-compute wti
wti = lookup(nch, 'GM_CGS', 'GM_ID', gm_ID, 'L', L);

for i = 1:length(vodfinal);

    for j = 1:length(beta)
        
        % compute CLtot based on noise
        CLtot = 2*kB*T*gamma./beta(j)/vod_noise^2;
        CFtot = CLtot./(CL_CFtot + 1-beta(j));

        % compute X and drain current
        X = vodfinal(i)*beta(j)./2*gm_ID;
        X(X<1) = 1;
        ID = CLtot/beta(j)./gm_ID/ts.*(X-1 - log(ed*X));
        
        % compute gm and Cgs
        gm = gm_ID.*ID;
        Cgs = gm./wti;
     
        % compute actual beta and find self-consistent point
        beta_actual = CFtot./(CFtot*(1+G) + Cgs);
        m = interp1(beta_actual, 1:length(beta_actual), beta(j), 'nearest', 0);
        if(m) 
            gm_ID_valid(j,i) = gm_ID(m);
            ID_valid(j,i) = ID(m);
            X_valid(j,i) = X(m);
        end
    end
end

[ID_min, idx] = min(ID_valid)
gm_ID_opt = diag(gm_ID_valid(idx,:))
slew_pct = (X_valid-1) ./ (X_valid-1-log(ed*X_valid));

h=figure;
subaxis(3,1,1,'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.03, 'MarginLeft', 0.15, 'MarginRight', 0.03)
plot(gm_ID_valid(:,1), ID_valid(:,1)*1e3, 'k--')
hold on;
plot(gm_ID_valid(:,2), ID_valid(:,2)*1e3, 'k-', 'linewidth', 2)
plot(gm_ID_valid(:,3), ID_valid(:,3)*1e3, 'k-.')
plot(gm_ID_opt(1), ID_min(1)*1e3, 'ko')
plot(gm_ID_opt(2), ID_min(2)*1e3, 'ko', 'linewidth', 2)
plot(gm_ID_opt(3), ID_min(3)*1e3, 'ko')
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(a)'})
ylabel('{\itI_D}  (mA)')
axis([min(gm_ID) max(gm_ID) 0 6])
grid;
legend('SS', '0.8V', '1.6V', 'location', 'southwest');

subaxis(3,1,2)
plot(gm_ID_valid(:,1), beta_rel, 'k--', gm_ID_opt(1), beta_rel(idx(1)), 'ko')
hold on;
plot(gm_ID_valid(:,2), beta_rel, 'k-', gm_ID_opt(2), beta_rel(idx(2)), 'ko', 'linewidth', 2)
plot(gm_ID_valid(:,3), beta_rel, 'k-.', gm_ID_opt(3), beta_rel(idx(3)), 'ko')
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(b)'})
ylabel('\beta/\beta_{\itmax}')
axis([min(gm_ID) max(gm_ID) 0.4 1])
grid;

subaxis(3,1,3)
plot(gm_ID_valid(:,1), slew_pct(:,1), 'k--', gm_ID_opt(1), slew_pct(idx(1),1), 'ko')
hold on;
plot(gm_ID_valid(:,2), slew_pct(:,2), 'k-', gm_ID_opt(2), slew_pct(idx(2),2), 'ko', 'linewidth', 2)
plot(gm_ID_valid(:,3), slew_pct(:,3), 'k-.', gm_ID_opt(3), slew_pct(idx(3),3), 'ko')
xlabel({'{\itg_m}/{\itI_D}  (S/A)'; '(c)'})
ylabel('{\itt_s_l_e_w}/{\itt_s}')
axis([min(gm_ID) max(gm_ID) -0.1 0.45])
grid;

%format_and_save(h, 'Fig6_13', 'H', 5.2)

%---------------------------------------------------------------
% inversion level for design
gm_ID = gm_ID_opt(2)
beta = beta(idx(2))
ID = ID_min(2)
vodfinal = vodfinal(2);

CLtot = 2*kB*T*gamma./beta/vod_noise^2
gm = ID*gm_ID

JD = lookup(nch,'ID_W', 'GM_ID', gm_ID, 'L', L)
W = ID/JD
CFtot = CLtot / (CL_CFtot + 1-beta)
CS = G*CFtot
CL = CL_CFtot*CFtot

Cgd = W*lookup(nch,'CGD_W', 'GM_ID', gm_ID, 'L', L)
CF = CFtot - Cgd
Cdb = W*lookup(nch,'CDD_W', 'GM_ID', gm_ID, 'L', L)- Cgd

SR = 2*ID/CLtot
tau = CLtot/gm/beta
vodlin = 2/gm_ID/beta
tslew = tau*(vodfinal/vodlin - 1)





