% 5.5.1   input noise PSD versus total input node cap
clearvars;
close all;
addpath ../../lib

% Parameters
wc = 2*pi*[1e8 1e9 1e10];
C = linspace(0.1e-12, 10e-12, 500);
CFP_C1 = 3;
kB = 1.3806488e-23;
T = 300;
gamma = 0.8;

N1 = 4*kB*T*gamma*wc(1)*C*CFP_C1;
N2 = 4*kB*T*gamma*wc(2)*C*CFP_C1;
N3 = 4*kB*T*gamma*wc(3)*C*CFP_C1;

h = figure;
loglog(C*1e12, sqrt(N1)*1e12, 'k-');
hold on;
loglog(C*1e12, sqrt(N2)*1e12, 'k-', 'linewidth', 2);
loglog(C*1e12, sqrt(N3)*1e12, 'k--');
xlabel('{\itC_S} + {\itC_F} + {\itC_g_g}  (pF)');
ylabel('Input current noise at {\itf} = {\itf_c}  (pA/rt-Hz)');
axis([0.1 10 1 100])
grid;
legend('{\itf_c} = 0.1 GHz', '{\itf_c} = 1.0 GHz', '{\itf_c} = 10 GHz', 'location', 'southeast');

%format_and_save(h, 'Fig5_30')



 

