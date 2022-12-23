% 2.3.6   gds/ID versus gm/ID
clear all
close all
addpath ../../lib
load 65nch.mat

% data ========================
L   = [.06 .1 .2 .5];
VGS = .2: .025: 1;


% compute ===================
gm_ID  = lookup(nch,'GM_ID','VGS',VGS,'L',L);
gds_ID = lookup(nch,'GDS_ID','VGS',VGS,'L',L);

X = [4 30];
for k = 1:length(L)
     y = XTRACT(nch,L(k),.6,0);
     SVT = y(6);
     SIS = y(7);
     Y(k,:) = - SVT*X + SIS;
end
 
% plot ========================
h = figure(1);
plot(gm_ID',gds_ID','k',X',Y','k--','linewidth', 1);
axis([0 30 0 2]); grid
xlabel('{\itg_m}/{\itI_D}  (S/A)');
ylabel('{\itg_d_s}/{\itI_D}  (S/A)');

text(21,.08,'500 nm', 'fontsize', 9)
text(21,.50,'200 nm', 'fontsize', 9)
text(18,1.1,'100 nm', 'fontsize', 9)
text(06,1.5,'{\itL} = 60 nm', 'fontsize', 9)


%format_and_save(h, 'Fig2_23')