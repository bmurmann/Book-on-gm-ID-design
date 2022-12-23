% Fig. A.3.4
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% Reference data
L = 0.1;
gm_ID0 = 15;
id_w0 = lookup(nch, 'ID_W', 'GM_ID', gm_ID0, 'L', L)
gm_gds0 = lookup(nch, 'GM_GDS', 'GM_ID', gm_ID0, 'L', L)
gm_cgg0 = lookup(nch, 'GM_CGG', 'GM_ID', gm_ID0, 'L', L)

% Spice data
load('FigA3_4.mat')
cgg = cgg_raw + cgsol + cgdol + cgbol;

% Compute
idx0 = find(W==10);
Erra0 = 100*(gm_ID0 - gm(idx0)./id(idx0)) ./ (gm(idx0)./id(idx0));
Erra = 100*(gm_ID0 - gm./id) ./ (gm./id);
Errb = 100*(gm_gds0 - gm./gds) ./ (gm./gds);
Errc = 100*(gm_cgg0 - gm./cgg) ./ (gm./cgg);

h1 = figure(1);
subaxis(2,1,1,'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.02, 'MarginLeft', 0.15, 'MarginRight', 0.03) 
semilogx(W, Erra, 'k-', 'linewidth', 2)
hold on;
semilogx(W, Errb, 'k-')
semilogx(W, Errc, 'k--', 'linewidth', 1)
semilogx(nch.W, Erra0, 'ko', 'linewidth', 2)
xlabel({'{\itW}  (\mum)'; '(a)'})
ylabel('Error  (%)')
grid;
legend('{\itg_m}/{\itI_D}', '{\itg_m}/{\itg_d_s}', '{\itg_m}/{\itC_g_g}', 'location', 'northeast')
subaxis(2,1,2)
semilogx(W, Erra, 'k-', 'linewidth', 2)
hold on;
semilogx(W, Errb, 'k-')
semilogx(W, Errc, 'k--', 'linewidth', 1)
semilogx(nch.W, Erra0, 'ko', 'linewidth', 2)
xlabel({'{\itW}  (\mum)'; '(b)'})
ylabel('Error  (%)')
grid;
axis([2 1e2 -2 2])

%format_and_save(h1, 'FigA3_4', 'H', 5)


