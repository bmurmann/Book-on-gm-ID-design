% Usage examples for lookup function
clearvars;
close all;
addpath ..

% load data in strcuture format
% all nmos data is contained in structure nch
% all pmos data is contained in structure pch
load 65nch.mat;
load 65pch.mat;
device = nch;

%Plot ID versus VDS
vds = device.VDS;
vgs = 0.4:0.05:0.6;
ID = lookup(device, 'ID', 'VDS', vds, 'VGS', vgs);
figure;
plot(vds, ID)
ylabel('I_D [A]')
xlabel('V_D_S [V]')
grid;

%Plot SPICE value of VT versus channel length
L = device.L;
vt = lookup(device, 'VT', 'VGS', 0.6, 'L', L);
figure;
plot(L, vt)
ylabel('V_T [V]')
xlabel('L [\mum]')
axis([0.06 0.3 0.38 0.42]);
grid;

%Plot ft against gm_id for different L
gm_id = 5:0.1:20;
ft = lookup(device, 'GM_CGG', 'GM_ID', gm_id, 'L', 0.06:0.05:0.3)/2/pi;
figure;
plot(gm_id, ft)
xlabel('g_m/I_D [S/A]')
ylabel('f_T [Hz]')

%Plot id/w against gm_id for different L
gm_id = 5:0.1:20;
id_w = lookup(device, 'ID_W', 'GM_ID', gm_id, 'L', 0.06:0.05:0.3);
figure;
semilogy(gm_id, id_w)
xlabel('g_m/I_D [S/A]')
ylabel('I_D/W [A/m]')

%Plot id/w against gm_id for different VDS (at minimum L)
gm_id = 5:0.1:20;
id_w = lookup(device, 'ID_W', 'GM_ID', gm_id, 'VDS', [0.8 1.0 1.2]);
figure;
semilogy(gm_id, id_w)
xlabel('g_m/I_D [S/A]')
ylabel('I_D/W [A/m]')

%Plot gm/gds against gm_id (at minimum L and default VDS)
gm_id = 5:0.1:20;
gm_gds = lookup(device,'GM_GDS','GM_ID', gm_id);
figure;
semilogy(gm_id, gm_gds)
xlabel('g_m/I_D [S/A]')
ylabel('g_m/g_d_s')

%Plot thermal noise factor gamma
kB = 1.38e-23;
gamma = lookup(device, 'STH_GM', 'GM_ID', gm_id)/(4*kB*device.TEMP);
figure;
semilogy(gm_id, gamma)
xlabel('g_m/I_D [S/A]')
ylabel('\gamma')

%try invalid syntax
ID = lookup(nch, 'ID', 'GM_ID', 8, 'GM', 0.00345)

%try invalid syntax
wt = lookup(nch, 'CGD', 'GM_ID', 10, 'L', 0.18);
