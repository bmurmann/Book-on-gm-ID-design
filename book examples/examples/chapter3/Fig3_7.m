% 3.1.4.   Basic trade-off exploration: fT and Av0 versus gm/ID
clear all
close all
addpath ../../lib
load 65nch.mat


% data ===========================
gmID = (2:25);          % (S/A)
L    = .06: .04: .18;   % (µm)


% compute ========================
Aintr = lookup(nch,'GM_GDS','GM_ID',gmID,'L',L);
fT    = lookup(nch,'GM_CGG','GM_ID',gmID,'L',L)/(2*pi);
for k = 1:length(L),
    gmID1(k) = interp1(fT(k,:),gmID,1e10); 
    Avo1(k)  = diag(interp1(gmID,Aintr(k,:),gmID1(k)));
end


% plot ===========================
h1 = figure(1);
[AX,H1,H2] = plotyy(gmID,1e-9*fT,gmID,Aintr,'plot');
Y1plot = 15/6*Avo1;
grid;

set(get(AX(1),'Ylabel'),'string','{\itf_T}  (GHz)')
set(get(AX(2),'Ylabel'),'string','{\itA_i_n_t_r}')
xlabel('{\itg_m}/{\itI_D}  (S/A)');
set(H1,'linestyle','-', 'linewidth', 1)
set(H2,'linestyle','--', 'linewidth', 1)
set(H1,'color', 'k')
set(H2,'color', 'k')

text(.8,41,'180 nm','FontSize', 9)
text(1.3,58,'140 nm','FontSize', 9)
text(2,80,'100 nm','FontSize', 9)
text(5,120,'{\itL} = 60 nm','FontSize', 9)

text(15,125,'{\itL} = 180 nm','FontSize', 9)
text(16.5,95,'140 nm','FontSize', 9)
text(20,70,'100 nm','FontSize', 9)
text(22,36,'60 nm','FontSize', 9)

text(3,110,'\leftarrow','fontsize', 20)
text(20,110,'\rightarrow','fontsize', 20)

%format_and_save(h1, 'Fig3_7', 'W', 5.3, 'H', 4)









