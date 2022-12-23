% Ex. 5.3  LDO SPICE verif (with optimal Co)
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat 
load Fig5_15.mat

GDa = gda*[.8 1 1.2];
% frequ response verif ==============
for k = 1:length(GDa),
    gda = GDa(k);
    N = [(Cgd*Cgs) (Cgs*gds+Cgd*(gds+gda+gm)) (gds*gda)];
    D = [(Co*(Cgd+Cgs)+Cgd*Cgs) (Co*gda+Cgd*gds+Cgs*gds+Cgd*gda+Cgd*gm ...
        -Cgd*gma+Cgd*Y+Cgs*Y) ((Y+gds)*gda+gm*gma)];
    
    RN = roots(N); z = RN(2)/(2*pi)
    p = roots(D)/(2*pi) 

    w   = logspace(4,12,100);  s = i*w;
    den = polyval(D,s);
    num = polyval(N,s);
    H(k,:) = num./den;
    %H   = num./den;
end

% plot ====================
h = figure(1);
subaxis(2,1,1,'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.02, 'MarginLeft', 0.15, 'MarginRight', 0.03); 
semilogx(w/(2*pi),20*log10(abs(H)),'k','linewidth',1); 
grid; 
axis([1e5 1e8 -80 -40])
xlabel({'{\itf}  (Hz)', '(a)'});
ylabel('|{\itv_o_u_t}/{\itv_d_d}|  (dB)');
hold on;
g = get(gca, 'children');
set(g(1), 'linestyle', '-.')
set(g(2), 'linestyle', '--')
set(g(3), 'linestyle', ':')
set(gca, 'xminorgrid', 'off');

subaxis(2,1,2); 
semilogx(w/(2*pi),180/pi*unwrap(angle(H)),'k','linewidth',1); %, ...
grid; axis([1e5 1e8 -100 20]); 
ylabel('\angle ({\itv_o_u_t}/{\itv_d_d})  (\circ)'); 
xlabel({'{\itf}  (Hz)', '(b)'});
hold on;
g = get(gca, 'children');
set(g(1), 'linestyle', '-.')
set(g(2), 'linestyle', '--')
set(g(3), 'linestyle', ':')
set(gca, 'xminorgrid', 'off');

% Load Spice results and plot on top
load('Fig5_18.mat')
magdb = 20*log10(abs(vout_re + 1j*vout_im));
phase = 180/pi*unwrap(angle(vout_re + 1j*vout_im));
f3dB = interp1(magdb, f, magdb(1)-3, 'spline')
f45deg = interp1(phase, f, -45, 'spline')

subaxis(2,1,1); 
semilogx(f, magdb,'k', 'linewidth', 1)
legend('Matlab, {\itg_d_s_a} -20%', 'Matlab, {\itg_d_s_a} nominal', 'Matlab, {\itg_d_s_a} +20%', 'SPICE', 'location', 'southwest');
subaxis(2,1,2); 
semilogx(f, phase,'k', 'linewidth', 1)
    
%format_and_save(h, 'Fig5_18', 'H', 4.6)



