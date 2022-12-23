% Usage examples of XTRACT.m function
clearvars;
close all;
addpath ..
 
load 65nch.mat;
load 65pch.mat;
 
% XTRACT(dev,L,VDS,VSB,rho) --> [VDS n VT JS d1n d1VT d1logJS d2n d2VT d2logJS];
 
 
% 1) plot n(VDS), VT(VDS) and JS(VDS) =====================================
VDS = .1*(2:9)';
y   = XTRACT(nch,.1,VDS,0);
n  = y(:,2);
VT = y(:,3);
JS = y(:,4);
 
d = (max(n) - min(n))/10;
figure(1); plot(VDS,n); axis([0 max(VDS)+.1 min(n)-d max(n)+d]); 
xlabel('V_D_S   (V)');
ylabel('n');
grid
 
d = (max(VT) - min(VT))/10;
figure(2); plot(VDS,VT); axis([0 max(VDS)+.1 min(VT)-d max(VT)+d]); 
xlabel('V_D_S   (V)');
ylabel('V_T   (V)');
grid
 
d = (max(JS) - min(JS))/10;
figure(3); plot(VDS,JS); axis([0 max(VDS)+.1 min(JS)-d max(JS)+d]); 
xlabel('V_D_S   (V)');
ylabel('J_S   [A\mum]');
grid
 
 
 
% 2) check d(VT)/d(VDS) against d1VT ==========================
a = diff(VT)./diff(VDS);
b = y(:,6);
figure(4); plot(VDS,b,.5*(VDS(1:end-1) + VDS(2:end)),a,'o')
xlabel('VDS   (V)'); title('d V_T / dV_D_S')
 
 
 
% 3) plot VT(VSB) ==========================================
VSB = .1*(0:8);
for k = 1:length(VSB)
    y = XTRACT(nch,.5,.6,VSB(k));
    VTbulk(k) = y(3);
end
figure(5); plot(VSB,VTbulk);
xlabel('V_S_B   (V)');
ylabel('V_T   (V)');
grid
 
 
 
% 4) plot influence of the default value rho on the threshold voltage ==========
rho = .5: .05: .9;
for k = 1:length(rho)
    y = XTRACT(nch,.1,.6,0,rho(k));
    VTrho(k) = y(3);
end
z = .5*(rho(1:end-1)+rho(2:end));
figure(6); plot(z,100*abs(diff(VTrho)/mean(VTrho)),'o-')
xlabel('rho');
ylabel('%');
title('abs(diff(V_T))');
grid
