% Fig. 6.28 Minimum current as a function of Cgs2/CC for Ex. 6.7
clearvars;
close all;
addpath ../../lib
load 65nch.mat
load 65pch.mat

% Specifications
s.G = 2;
s.FO = 0.5;
s.fu1 = 220e6;
s.fp2 = 6*s.fu1;
s.vod_noise = 400e-6;
s.L0 = 50;
beta_max = 1/(1+s.G);

% Design decisions and estimates
d.L1 = 0.15; d.L2 = 0.2; d.L3 = 0.2; d.L4 = 0.15;
d.gam1 = 0.8; d.gam2 = 0.8; d.gam3 = 0.8; d.gam4 = 0.8;
d.gm3_gm1 = 1; d.gm4_gm2 = 0.5;

% Search range for main knobs
cltot_cc = linspace(0.2, 1.5, 100);
d.beta = beta_max*linspace(0.4, 0.95, 100)';

% Iterate
if(0)
    for k = 1:length(cgs2_cc);
        d.cgs2_cc = cgs2_cc(k);
        rself1 = zeros(1, 10);
        rself2 = zeros(1, 10);
        for i = 1:length(rself1)
            for j=1:length(cltot_cc)
                d.cltot_cc = cltot_cc(j);
                d.rself1 = rself1(i);
                d.rself2 = rself2(i);
                
                [m1, m2, m3, m4, p] = two_stage(pch, nch, nch, pch, s, d);
                ID1(j,:) = m1.id;
                ID2(j,:) = m2.id;
                rself1_out(j,:) = p.rself1;
                rself2_out(j,:) = p.rself2;
            end
            
            % Find optimum and evaluate self loading at optimum
            IDtot = ID1 + ID2;
            [IDtot_opt, idx] = min(IDtot(:));
            [idx1, idx2] = ind2sub(size(IDtot), idx);
            rself1(i+1) = rself1_out(idx1, idx2);
            rself2(i+1) = rself2_out(idx1, idx2);
            beta_opt = d.beta(idx2);
            cltot_cc_opt = cltot_cc(idx1);
            ID1_opt = ID1(idx1, idx2);
            ID2_opt = ID2(idx1, idx2);
        end
        
        IDtot_k(k) = IDtot_opt;
        ID1_opt_k(k) = ID1_opt;
        ID2_opt_k(k) = ID2_opt;
        beta_opt_k(k) = beta_opt;
        cltot_cc_opt_k(k) = cltot_cc_opt;
        rself1_k(k) = rself1(end);
        rself2_k(k) = rself2(end);
    end
    save('Fig6_28.mat', 'IDtot_k', 'beta_opt_k', 'cltot_cc_opt_k', 'cgs2_cc', 'rself1_k', 'rself2_k', 'ID1_opt_k', 'ID2_opt_k');    
end

% read data
load Fig6_28.mat;

h1 = figure;
plot(cgs2_cc, IDtot_k*1e6, 'k-o', 'linewidth', 1.01)
xlabel('{\itC_g_s_2}/{\itC_C}');
ylabel('{\itI_D_1}+{\itI_D_2}  (\muA)');
axis([min(cgs2_cc) max(cgs2_cc) 0 1.1*max(IDtot_k*1e6)])
grid;

%format_and_save(h1, 'Fig6_28')

% final design
idx = find(cgs2_cc>=0.29, 1, 'first');
d.cltot_cc = cltot_cc_opt_k(idx);
d.beta = beta_opt_k(idx);
d.rself1 = rself1_k(idx);
d.rself2 = rself2_k(idx);
d.cgs2_cc = cgs2_cc(idx);

[m1, m2, m3, m4, p] = two_stage(pch, nch, nch, pch, s, d)

ID1_opt_k(idx)
ID2_opt_k(idx)
IDtot_k(idx)
d.beta/beta_max
d.cltot_cc

