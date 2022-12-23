% Ex. 5.3  LDO poles and zeros
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat 
load Fig5_15.mat

Co
% compute ==================
z = 21;
CC = Co*logspace(-3,+3,z)'; 

% denominator of v/vdd =========
D2 = CC*(Cgd+Cgs) + Cgs*Cgd;
D1 = CC*gda + (Cgs+Cgd)*(Y+gds) + Cgd*(gda+gm-gma);
D0 = gm*gma + (Y+gds)*gda;
PD = [D2 D1 D0*ones(z,1)]; 
for m = 1:z,
    s(m,:) = roots(PD(m,:))'/(2*pi);
end

% numerator of v/vdd (does not depend on CC)=========
N2 = Cgd*Cgs;
N1 = Cgs*gds+Cgd*(gds+gda+gm);
N0 = gds*gda;
PN = [N2 N1 N0];
z  = roots(PN)/(2*pi);
zero = abs(z(2))
fc

% plot =====================
h = figure(1);
plot(real(s),imag(s),'+k',z(2),0,'ok','linewidth',1.01);
axis(1e7*[-2 0 -15 15]); 
xlabel('Real part  (Hz)'); 
ylabel('Imaginary part  (Hz)');
grid;
text(-0.4e7, 1.2e8, '{\its}-plane', 'fontsize', 9, 'edgecolor', 'k');

%format_and_save(h, 'Fig5_17')
