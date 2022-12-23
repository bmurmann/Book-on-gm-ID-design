% Fig. 6.19 Folded cascode OTA optimization with self loading
clearvars;
close all;
addpath ../../lib
load 65nch.mat
load 65pch.mat

% Compute required unity gain frequency
s.ts = 5e-9;
s.ed = 0.1e-2;
s.fu1 = 1/2/pi * log(1/s.ed)/s.ts;
fp2 = 2e9;
fp2/s.fu1;

% Other design specifications
s.vod_noise = 400e-6;
s.FO = 0.5;
s.G = 2;
beta_max = 1/(1+s.G);

% Design choices and constants
d.gamma = 0.7;
d.Lcas = 0.4;
d.gm_IDcas = 15;

% Search parameter setup
d.L1=0.2;
cself = zeros(1,6);
d.gm_ID1 = (5:0.01:27)';
d.beta = beta_max*(0.2:0.001:1)';

% Self loading sweep
for i = 1:length(cself)
    d.cself = cself(i);
    [m1 p] = folded_cascode(pch, nch, s, d);

    % find minimum current point
    [ID1(i) m] = min(m1.ID); 
    gm_ID1(i) = m1.gm_ID(m); 
    cltot(i) = p.cltot(m); 
    beta(i) = d.beta(m); 
        
    % Use actual self loading at optimum as guess for next iteration
    cself(i+1) = p.cself(m);
end

% Plot
h = figure;
subaxis(2,1,1, 'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.03, 'MarginLeft', 0.14, 'MarginRight', 0.03)
plot(1:length(cltot), cself(1:end-1)./cltot, 'k-o', 'linewidth', 1)
xlabel({'Iteration'; '(a)'});
ylabel('{\itr_s_e_l_f}');
axis([1 length(ID1) 0 0.3])
grid;

subaxis(2,1,2)
plot(1:length(ID1), ID1*1e3, 'k-o', 'linewidth', 1)
xlabel({'Iteration'; '(b)'});
ylabel('{\itI_D_1}  (mA)');
axis([1 length(ID1) 0 0.2]);
grid;

%format_and_save(h, 'Fig6_19', 'H', 4.8);

% Final sizing point
ID1_opt = ID1(end);
gm_ID1_opt = gm_ID1(end);
beta_opt = beta(end);
CLtot = cltot(end);
Cself = cself(end);
beta_opt/beta_max

% Compute all capacitances
CF = (CLtot-Cself)./(s.FO*s.G + 1-beta_opt);
CS = s.G*CF;
CL = s.FO*CS;

% Find current densities and widths
ID_W1 = lookup(pch, 'ID_W', 'GM_ID', gm_ID1_opt, 'L', d.L1);
ID_W2 = lookup(nch, 'ID_W', 'GM_ID', d.gm_IDcas, 'L', d.Lcas, 'VDS', 0.2);
ID_W5 = lookup(pch, 'ID_W', 'GM_ID', d.gm_IDcas, 'L', d.Lcas, 'VDS', 0.2);
W1 = ID1_opt/ID_W1;
W2 = 2*ID1_opt/ID_W2;
W3 = W2/2;
W5 = ID1_opt/ID_W5;
W4 = W5;

