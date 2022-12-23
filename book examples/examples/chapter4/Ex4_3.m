% Ex. 4.3
clearvars;
close all;
addpath ../../lib
load 65nch.mat

k = 1.3806488e-23;
T = 300;
gamma = 1;

% Estimate kf
kf = (57e-9)^2 * 10e-6 * 0.1e-6 * 12e3

L = [0.06 0.06 0.25 0.25];
gm_id = [10 25 10 15];

for i = 1:length(L)
    gm_w = lookup(nch, 'GM_W', 'GM_ID', gm_id(i), 'L', L(i))
    fco(i) = kf/L(i)/4/k/T/gamma*gm_w*1e6;
end

fco'
