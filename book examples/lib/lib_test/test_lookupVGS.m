% Usage examples for lookupVGS function
clearvars;
close all;
addpath ..
load 65nch.mat

%% Example with unknown source voltage
gm_ID = 15;
VGB   = .9;
VDB   = .7;

% find VGS and VS
VGS = lookupVGS(nch, 'GM_ID', gm_ID,'VDB',VDB,'VGB',VGB)
VSB  = VGB - VGS  % VS does not change much with VDB 
 
% now check to make sure the same gm/ID comes our from forward
% interpolation
gmID = lookup(nch,'GM_ID','VGS',VGS,'VDS',VDB-VSB,'VSB',VSB)
    
%% Example with vector input for L

gm_ID = 15;
L = 0.1:0.1:0.5;
VGS = lookupVGS(nch, 'GM_ID', gm_ID, 'L', L)

%% Example with vector input for gm/ID

gm_ID = 5:10;
VGS = lookupVGS(nch, 'GM_ID', gm_ID, 'L', 0.25)


%% Example with ID_W as input

gm_ID =10:12;
ID_W = lookup(nch,'ID_W','GM_ID', gm_ID)
VGS = lookupVGS(nch, 'GM_ID', gm_ID)
VGS = lookupVGS(nch, 'ID_W', ID_W)

    
%% Example with known and positive VSB
% The issue is that gm/ID drops again for VGS near zero and the function
% may then catch the wrong intercept. To fix this, the function looks only
% to the right of the maximum value for gm/ID

VSB = 0.8;
VDS = 0.2;
gm_ID = lookup(nch,'GM_ID','VGS',nch.VGS,'VSB',VSB, 'VDS', VDS);
gmid = max(gm_ID)-0.05;
VGS = lookupVGS(nch, 'GM_ID', gmid,'VSB',VSB,'VDS',VDS)
plot(nch.VGS, gm_ID, VGS, gmid, 'o')


%% Example with vector input for mode 2 -- L

VSB = 0.8;
VDS = 0.2;
VGS = lookupVGS(nch, 'GM_ID', gmid,'VSB',VSB,'VDS',VDS, 'L', 0.1:0.1:0.2)


%% Example with vector input for mode 2 -- VDS

VSB = 0.8;
VDS = 0.2:0.1:0.5;
VGS = lookupVGS(nch, 'GM_ID', gmid,'VSB',VSB,'VDS',VDS)

%% Example with values exceeding maximum

gm_ID = 50;
VGS = lookupVGS(nch, 'GM_ID', gm_ID, 'L', 0.25)








