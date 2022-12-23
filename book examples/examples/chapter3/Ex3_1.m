% Example 3.1   A basic sizing example.
clearvars;
close all
addpath ../../lib
load 65nch.mat


% data ========================
fu = 1e9;   % (Hz)
CL = 1e-12; % (F)
gm_ID = 15; % (S/A)
 

 
% compute transcoductance ====================
    gm  = 2*pi*fu*CL; 
% drain current
    ID  = gm/gm_ID
% drain current density (default values for VDS, VSB and L)
    JD  = lookup(nch,'ID_W','GM_ID',gm_ID)
% width
    W   = ID/JD
% gate-to-source voltage
    VGS = lookupVGS(nch,'GM_ID',gm_ID)
% low frequency gain
    Av0 = lookup(nch,'GM_GDS','GM_ID',gm_ID)
% transit frequency
    fT  = lookup(nch,'GM_CGG','GM_ID',gm_ID)/(2*pi)
% Fan Out
    FO  = fT/fu
% Early voltage
    VEA = Av0/gm_ID