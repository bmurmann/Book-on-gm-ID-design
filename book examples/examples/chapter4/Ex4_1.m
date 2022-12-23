% Ex. 4.1
clearvars;
close all;
addpath ../../lib;
load 65nch;

% Constants and design parameters
kB = 1.38e-23;
T = nch.TEMP;
gamma_n = 0.8;
vin_noise = 1e-9;
L = 0.06;

% Set inversion level to sweet spot
gm_ID = 7;

% Compute gm based on noise specification
gm = 4*kB*T*gamma_n/vin_noise^2

% Compute drain curent and device width
ID = gm/gm_ID
JD = lookup(nch, 'ID_W', 'GM_ID', gm_ID, 'L', L)
W = ID/JD
