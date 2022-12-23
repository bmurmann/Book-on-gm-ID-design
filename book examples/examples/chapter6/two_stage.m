function [m1, m2, m3, m4, p] = two_stage(dev1, dev2, dev3, dev4, s, d)

m1.L=d.L1;
m2.L=d.L2;
m3.L=d.L3;
m4.L=d.L4;

%----------------------------------------------------
% Calculate Cc and all other caps from noise spec
kT = 1.3806488e-23*dev1.TEMP;

p.cc = (2./d.beta*kT*d.gam1*(1 + d.gam3/d.gam1*d.gm3_gm1) ...
    + 1/d.cltot_cc*kT*(1+d.gam2*(1 + d.gam4/d.gam2*d.gm4_gm2)))/ s.vod_noise^2;
p.cltot = p.cc*d.cltot_cc;
p.cf = p.cltot/(1+d.rself2)./( 1-d.beta + s.FO*s.G);
p.cs = p.cf*s.G;
p.cl = p.cs*s.FO;
m2.cgs = p.cc.*d.cgs2_cc;
p.c1 = m2.cgs*(1+d.rself1);


%----------------------------------------------------
% Calculations for M1
gmR = sqrt(s.L0)./d.beta;
m1.gm = 2*pi*s.fu1.*p.cc./d.beta .* (1 + (1+p.c1./p.cc)./gmR + (1+p.cltot./p.cc)./gmR);
m1.cgg = p.cf.*(1./d.beta -1-s.G);
m1.ft = m1.gm./m1.cgg/2/pi;
m1.gm_id = lookup(dev1, 'GM_ID', 'GM_CGG', 2*pi*m1.ft, 'L', m1.L, 'WARNING', 'OFF');
m1.id = m1.gm./m1.gm_id;

%----------------------------------------------------
% Calculations for M2
m2.gm = 2*pi*s.fp2*(1 + p.cltot./p.cc + p.cltot./p.c1).*p.c1;
m2.fts = m2.gm./m2.cgs/2/pi;
m2.gm_id = lookup(dev2, 'GM_ID', 'GM_CGS', m2.fts*2*pi, 'L', m2.L, 'WARNING', 'OFF');
m2.id = m2.gm./m2.gm_id;
p.rz=1./m2.gm;

%----------------------------------------------------
% Calculate widths
m3.gm_id = m1.gm_id.*d.gm3_gm1;
m4.gm_id = m2.gm_id.*d.gm4_gm2;
m1.W = m1.id./lookup(dev1, 'ID_W', 'GM_ID', m1.gm_id, 'L', m1.L);
m2.W = m2.id./lookup(dev2, 'ID_W', 'GM_ID', m2.gm_id, 'L', m2.L);
m3.W = m1.id./lookup(dev3, 'ID_W', 'GM_ID', m3.gm_id, 'L', m3.L);
m4.W = m2.id./lookup(dev4, 'ID_W', 'GM_ID', m4.gm_id, 'L', m4.L);

%----------------------------------------------------
% Neutralization and comp cap size
m1.cgd = m1.W.*lookup(dev1, 'CGD_W', 'GM_ID', m1.gm_id, 'L', m1.L);
p.cn = m1.cgd;
m2.cgd = m2.W.*lookup(dev2, 'CGD_W', 'GM_ID', m2.gm_id, 'L', m2.L);
p.cc_add = p.cc-m2.cgd;

%----------------------------------------------------
% Self loading calculation
m1.cdd = m1.W.*lookup(dev1, 'CDD_W', 'GM_ID', m1.gm_id, 'L', m1.L);
m2.cdd = m2.W.*lookup(dev2, 'CDD_W', 'GM_ID', m2.gm_id, 'L', m2.L);
m3.cdd = m3.W.*lookup(dev3, 'CDD_W', 'GM_ID', m3.gm_id, 'L', m3.L);
m4.cdd = m4.W.*lookup(dev4, 'CDD_W', 'GM_ID', m4.gm_id, 'L', m4.L);
p.rself1 = (m1.cdd+m3.cdd)./m2.cgs;
p.rself2 = ((m2.cdd-m2.cgd)+m4.cdd) ./ (p.cl + (1-d.beta).*p.cf);

