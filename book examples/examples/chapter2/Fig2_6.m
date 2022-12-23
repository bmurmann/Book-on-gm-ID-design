% 2.2.2   ID(VGS) + WI and SI approx of E.K.V. model
clear
close all;
addpath ../../lib

% data ------------------------------------------------------
n   = 1.3;              % slope factor
IS  = 1e-6;            % specific current A
VT  = .4;               % threshold voltage V
VG  = (0: .02: 1.2)';   % gate voltage V

% compute ----------------------------------------------------
UT = .026;
VP = (VG - VT)/n;
qS = invq(VP/UT);
i = qS.^2 + qS;
ID = i*IS;
VG = n*VP + VT;

% plot --------------------------
h = figure(1); semilogy(VG,ID,'k--',VG,qS.^2*IS,'k',VG,qS*IS,'k',...
    'linewidth',1)
axis([0 1.2 1e-14 1e-3]); grid
xlabel('{\itV_G_S}  (V)'); ylabel('{\itI_D}  (A)'); 



%format_and_save(h, 'FIG2_06')











