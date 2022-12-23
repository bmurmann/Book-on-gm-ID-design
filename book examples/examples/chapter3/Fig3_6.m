% Example 3.1  SPICE simulation
clearvars;
close all;

addpath ../../lib
load 65nch.mat

% Sizing
fu = 1e9;
CL = 1e-12;
gmID = 15;
L = 0.06;
gm  = 2*pi*fu*CL;
ID  = gm/gmID;
JD  = lookup(nch,'ID_W','GM_ID',gmID,'L',L);
W   = ID/JD

% Load Spice results
load('Fig3_6.mat')
fu_sim = exp(interp1(log(vout), log(f), 0));
Avo_sim = vout(1);

h1 = figure(1);
loglog(f, vout, 'k', fu_sim, 1, 'ko', 'linewidth', 1);
hold on;
loglog(f, ones(1,length(f)), 'k:');
xlabel('{\itf}  (Hz)');
ylabel('|{\itA_v}|');
axis([1e4 1e10 0.3 20]);
text(1e5, 12.5, num2str(Avo_sim, '%1.2f'), 'fontsize', 9);
text(4e8, 0.7,  [num2str(fu_sim*1e-9, '%1.4f') ' GHz'], 'fontsize', 9, 'backgroundcolor', [1 1 1]);

%format_and_save(h1, 'Fig3_6')



