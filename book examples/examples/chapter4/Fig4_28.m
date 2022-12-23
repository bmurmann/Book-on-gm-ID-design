% Example 4.5   impact of load resistor on HD2 and Av0
clearvars;
close all;
addpath ../../lib
load 65nch.mat;

% 1) data ===============
VDD   = 1.2;
UDS   = .6;
fT    = 1e9;
CL    = 1e-12;
gm_ID = 15;     % nch
L     = .06;    % nchsize(y)

% 2) size IGS ====================
gm1o = 2*pi*fT*CL;
IDo = gm1o/gm_ID
JDo = lookup(nch,'ID_W','GM_ID',gm_ID,'L',L)
W   = IDo/JDo

% 3) compute gain A and load resistance R ==============
VGS  = lookupVGS(nch,'GM_ID',gm_ID,'VDS',UDS,'L',L);
y    = blkm(nch,L,UDS,VGS);
gm2o = W*y(4); 
gd1o = W*y(2); 
gd2o = W*y(5); 
x11o = W*y(6); 

a1 = (-x11o + sqrt(x11o^2 - gm2o*gd2o))/(gd2o)  % gain making HD2 = 0
Y  = (- gm1o/a1 - gd1o);                        % load coductance
R  = 1/Y

% 4)sensitivity to R =========
r = 500*(1:.02:10); y = 1./r;
a1 = - gm1o./(y + gd1o);
a2 = -(.5*gm2o + x11o*a1 + .5*gd2o*a1.^2)./(y + gd1o);
HD2 = 20*log10(.5*abs(a2./a1)*.01);

% RL sweep
gds = 0.6138e-3;
gm = 6.288e-3;
RL = logspace(log10(500), log10(5000), 100);
Av = gm./(gds+1./RL);

% Spice data
load('Fig4_28.mat')
hd2 = vo(3,:)./vo(2,:);
hd2_db = 20*log10(hd2);

% plot
h = figure(1);
subaxis(2,1,1,'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.01, 'MarginLeft', 0.15, 'MarginRight', 0.04); 
plot(RL/1e3, hd2_db, 'linewidth', 4, 'color', 0.8*[1 1 1])
hold on;
plot(r/1e3,HD2,'k', 'linewidth', 1)
ylabel('HD_2 (dB)')
xlabel({'{\itR}  (k\Omega)';'(a)'})
grid;
axis([0.5 4 -100 -20])
legend('SPICE', 'Matlab', 'location', 'southeast')

subaxis(2,1,2)
plot(RL/1e3, Av, 'linewidth', 4, 'color', 0.8*[1 1 1])
hold on;
plot(r/1e3,abs(a1),'k', 'linewidth', 1)
ylabel('|{\itA_v}|')
xlabel({'{\itR}  (k\Omega)';'(b)'})
grid;
axis([0.5 4 0 10])
legend('SPICE', 'Matlab', 'location', 'southeast')

%format_and_save(h, 'Fig4_28', 'H', 4.5);
 
    
    
    