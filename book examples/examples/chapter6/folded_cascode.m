function [m1, p] = folded_cascode(dev1, dev2, s, d)

kB = 1.3806488e-23;
gm_gds1 = lookup(dev1, 'GM_GDS', 'GM_ID', d.gm_ID1, 'L', d.L1);
wt1 = lookup(dev1, 'GM_CGG', 'GM_ID', d.gm_ID1, 'L', d.L1);
cgd_cgg1 = lookup(dev1, 'CGD_CGG', 'GM_ID', d.gm_ID1, 'L', d.L1);
gm_gds2 = lookup(dev2, 'GM_GDS', 'GM_ID', d.gm_IDcas, 'L', d.Lcas);
cdd_gm3 = lookup(dev2, 'CDD_GM', 'GM_ID', d.gm_IDcas, 'L', d.Lcas);
cdd_gm4 = lookup(dev1, 'CDD_GM', 'GM_ID', d.gm_IDcas, 'L', d.Lcas);

m1.ID = NaN(1,length(d.beta));
m1.gm_ID = NaN(1,length(d.beta));
p.cltot = NaN(1,length(d.beta));

for j = 1:length(d.beta)

    % Compute excess noise factor and total load to meet the noise spec
    alpha = 2*d.gamma*(1+ d.gm_IDcas./d.gm_ID1 + 2*d.gm_IDcas./d.gm_ID1);
    cltot = alpha./d.beta(j)*kB*dev1.TEMP/s.vod_noise^2;
    CF = (cltot-d.cself)./(s.FO*s.G + 1-d.beta(j));
    CS = s.G*CF;
    
    % Estimate kappa and compute required gm for given fu1
    kappa = 1./(1+ 1./gm_gds1.*d.gm_ID1/d.gm_IDcas + 2/gm_gds2);
    gm1 = 2*pi*s.fu1*cltot./d.beta(j)./kappa;
    ID1 = gm1./d.gm_ID1;

    % Compute actual feedback factor and find match
    cgs1 = gm1./wt1;
    cin = cgs1.*(1 + cgd_cgg1.*d.gm_ID1/d.gm_IDcas);
    beta_actual = CF./(CF+CS+cin);
    m = interp1(beta_actual, 1:length(beta_actual), d.beta(j), 'nearest', 0);
    if(m)
        m1.ID(j) = ID1(m);
        m1.gm_ID(j) = d.gm_ID1(m);
        p.cltot(j) = cltot(m);
    end  
end

% self loading
gm34 = m1.ID.*d.gm_IDcas;
p.cself = gm34*cdd_gm3 + gm34*cdd_gm4;

end 