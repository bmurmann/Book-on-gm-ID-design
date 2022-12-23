% 4.1.2   Product of fT and gm/ID
clear all;
close all;
addpath ../../lib;
load 65nch;


% data ==================
gm_id = (3:0.01:20)';
l = [0.06 0.1 0.25];

% compute ==================
h = figure(1);
wt = lookup(nch, 'GM_CGG', 'GM_ID', gm_id, 'L', l);
fom = wt'/2/pi.*(gm_id*ones(1,length(l)));


%plot =====================
plot(gm_id, 1e-9*fom, 'k', 'linewidth', 1);
grid;
xlabel('{\itg_m}/{\itI_D}  (S/A)');
ylabel('{\itf_T\cdotg_m}/{\itI_D} (GHz\cdotS/A)');
axis([3 20 0 700]);

h1 = text(12, 550, '{\itL}=60nm');
h2 = text(11, 360, '{\itL}=100nm');
h3 = text(11, 120, '{\itL}=250nm');
f=9;
set(h1, 'FontSize', f);
set(h2, 'FontSize', f);
set(h3, 'FontSize', f);

%format_and_save(h, 'Fig4_4')
