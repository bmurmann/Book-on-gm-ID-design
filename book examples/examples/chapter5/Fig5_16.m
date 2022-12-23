%5.3.2   frequency response closed loop LDO versus C
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat  
load Fig5_15.mat

% data ==================
z = 5; CC = logspace(-14,-6,z)';

% frequ response ==============
w   = logspace(4,11,200);  s = i*w;
    
% numerator of v/vdd =========
N2 = Cgd*Cgs;
N1 = Cgs*gds + Cgd*(gds+gda+gm);
N0 = gds*gda;
PN = [N2 N1 N0];
num = polyval(PN,s);

for k = 1:length(CC)
    Cx = CC(k);
    % denominator of v/vdd =========
    D2 = Cx*(Cgd+Cgs) + Cgd*Cgs;
    D1 = Cx*gda + (Cgs+Cgd)*(Y+gds) + Cgd*(gda+gm-gma) ;
    D0 = gm*gma + (Y+gds)*gda;
    PD = [D2 D1 D0]; 
    den = polyval(PD,s);
    
    M(k,:) = num./den; 
end 


% plot ====================
h = figure(1)
subaxis(2,1,1,'Spacing', 0.13, 'MarginBottom', 0.13, 'MarginTop', 0.02, 'MarginLeft', 0.15, 'MarginRight', 0.03); 
semilogx(w/(2*pi),20*log10(abs(M)),'k','linewidth',1); 
grid; axis([1e4 1e10 -130 0])
g = get(gca, 'children')
set(g(1), 'linestyle', '-', 'color', 0.7*[1 1 1])
set(g(2), 'linestyle', ':')
set(g(3), 'linestyle', '-.')
set(g(4), 'linestyle', '--')
set(g(5), 'linestyle', '-')
ylabel('|{\itv_o_u_t}/{\itv_d_d}|  (dB)');
xlabel({'{\itf}  (Hz)';'(a)'});
g = legend('10 fF', '1 pF', '100 pF', '10 nF', '1 \muF', 'location', 'southwest');
set(g, 'fontsize', 9);


subaxis(2,1,2); semilogx(w/(2*pi),180/pi*unwrap(angle(M)),'k','linewidth',1); 
grid; axis([1e4 1e10 -100 100]); 
g = get(gca, 'children')
set(g(1), 'linestyle', '-', 'color', 0.7*[1 1 1])
set(g(2), 'linestyle', ':')
set(g(3), 'linestyle', '-.')
set(g(4), 'linestyle', '--')
set(g(5), 'linestyle', '-')
ylabel('\angle ({\itv_o_u_t}/{\itv_d_d}) (\circ)'); 
xlabel({'{\itf}  (Hz)';'(b)'});

%format_and_save(h, 'Fig5_16', 'H', 4.5)
