% Example 6.2
clearvars;
close all;
addpath ../../lib
load 65nch.mat

% Parameters
L = 0.1;
CL_CFp = 2;
CS_CFp = 2;
gm_ID = 20.4;
fc= 1e9;
Noise = 100e-6;
kB = 1.3806488e-23;
T = nch.TEMP;
gamma = 0.7;

% Compute
beta_max = 1/(1+CS_CFp);
beta = 0.825*beta_max
CLtot = 2*gamma/beta * kB*T/Noise^2
gm = CLtot *2*pi*fc/beta
ID = gm/gm_ID
ID*1000

JD = lookup(nch,'ID_W', 'GM_ID', gm_ID, 'L', L)
W = ID/JD
CFp = CLtot / (CL_CFp + 1-beta)
CS = CS_CFp*CFp
CL = CL_CFp*CFp

Cgd = W*lookup(nch,'CGD_W', 'GM_ID', gm_ID, 'L', L)
CF = CFp - Cgd

Cdb = W*lookup(nch,'CDD_W', 'GM_ID', gm_ID, 'L', L)- Cgd
Noise_est = sqrt(2*0.68/beta * kB*T/(CLtot+Cdb))

gm_gds = lookup(nch,'GM_GDS', 'GM_ID', gm_ID, 'L', L)
err = 1/(beta*gm_gds)
err_db = 20*log10(1-err)
tau = 1/2/pi/fc
ts = -tau*log(0.1e-2)




