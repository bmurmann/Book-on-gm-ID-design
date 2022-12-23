% Fig. A.3.6
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% Reference data
L = [0.06, 0.1, 0.2, 0.5, 1];
gm_ID0 = [5 10 15 20];
jd_wi = 1e-9;

gm_cgg0 = lookup(nch, 'GM_CGG', 'GM_ID', gm_ID0, 'L', L);
gm_cgg_wi = lookup(nch, 'GM_CGG', 'ID_W', jd_wi, 'L', L);
% append weak inversion data
gm_cgg0 = [gm_cgg0 gm_cgg_wi];

% Spice data
files = {...
'FigA3_5_60n.mat',...
'FigA3_5_100n.mat',...
'FigA3_5_200n.mat',...
'FigA3_5_500n.mat',...
'FigA3_5_1000n.mat'
};

% Compute
max_err = NaN(length(gm_cgg0), length(L));
min_err = NaN(length(gm_cgg0), length(L));
for i = 1:length(files)
    load(files{i});
    cgg = cgg_raw + cgsol + cgdol + cgbol;
    err = 100*(bsxfun(@minus, gm_cgg0(i,:), gm./cgg) ./ (gm./cgg));
    max_err(i,:) = max(abs(err));
    min_err(i,:) = min(abs(err));
end
min_err

h1 = figure(1);
loglog(L, max_err(:,1), 'k<', 'linewidth', 1.05)
hold on;
loglog(L, max_err(:,2), 'kd', 'linewidth', 1.05)
loglog(L, max_err(:,3), 'k^', 'linewidth', 1.05)
loglog(L, max_err(:,4), 'kd', 'linewidth', 1.05)
loglog(L, max_err(:,5), 'ko', 'linewidth', 1.05)
xlabel('{\itL}  (\mum)')
ylabel('Maximum error in {\itg_m}/{\itC_g_g}  (%)')
set(gca,'YGrid','on')
set(gca,'YMinorGrid','off')
axis([3e-2 2 1e-2 10])
legend(...
'5 S/A',...
'10 S/A',...
'15 S/A',...
'20 S/A',...
'{\itJ_D} = 1 nA/\mum',...
'location', 'southeast')

%format_and_save(h1, 'FigA3_6')
