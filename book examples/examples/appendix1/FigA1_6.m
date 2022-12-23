% A.1.6   reconstruct corner ID, gm/ID versus VGS (Table A.1.2)
clear all
close all
addpath ../../lib

files = {'65nch_slow_hot.mat', '65nch.mat', '65nch_fast_cold.mat'}; 

% data =============
VDS = .6;   
VBS = .0;      
L   = .1;
rho = .6;


for k = 1:length(files)
    load(files{k});
    Temp(k,1)  = nch.TEMP;
    JD(:,k)  = lookup(nch,'ID_W','L',L); 
end
TCelsius = Temp - 273

VGS = nch.VGS; z = length(VGS);
gm_ID = diff(log(JD))./diff(VGS(:,ones(1,3))); 
[a b] = max(gm_ID);
M = diag(gm_ID(b,:))

% param =========
UT  = .0259*Temp/300;
n = 1./(M.*UT)
UGS     = .5*(VGS(1:z-1) + VGS(2:z));
for k = 1:3,
    VGSo(k,1) = interp1(gm_ID(:,k),UGS,rho*M(k),'cubic');
    JDo(k,1)  = interp1(VGS,JD(:,k),VGSo(k),'cubic');
end

%plot(UGS,gm_ID,VGSo,M*rho,'o'); return
%semilogy(VGS,ID,VGSo,IDo,'+');  return

qFo = 1/rho - 1;
io  = qFo.^2 + qFo;
VPo = UT*(2*(qFo-1) + log(qFo));
VT  = VGSo - n.*VPo;
JS  = JDo/io;
beta = JS./(2*n.*UT.^2),
y   = [Temp'; n'; VT'; JS'*1e6; beta'*1e3] 


% reconstruct ================
    for k = 1:3,
    VPS = (VGS-VT(k))/n(k);
    qF  = invq(VPS/UT(k));
    jD(:,k)  = JS(k)*(qF.^2 + qF);
    gm_Id(:,k) = 1./(n(k)*UT(k)*(1+qF));
    end 
     

% plot =============
h = figure(1);
hold on;
subaxis(2,2,1,'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.02, 'MarginLeft', 0.12, 'MarginRight', 0.03) 
semilogy(VGS,JD,'k', VGS,jD,'k+', 'markersize', 5, 'linewidth', 1.05);
hold on;
subaxis(2,2,2); 
semilogy(VGS,JD,'k', VGS,jD,'k+', 'markersize', 5, 'linewidth', 1.05);
hold on;
subaxis(2,2,3); 
plot(UGS,gm_ID,'k',VGS,gm_Id,'k+', 'markersize', 5, 'linewidth', 1.05);
hold on;
subaxis(2,2,4); 
plot(UGS,gm_ID,'k',VGS,gm_Id,'k+', 'markersize', 5, 'linewidth', 1.05);
hold on;


subaxis(2,2,1);
grid;
axis([0 1.2 1e-11 1e-2]);
xlabel({'{\itV_G_S}   (V)'; '(a)'});
ylabel('{\itJ_D}   (A/\mum)')
set(gca, 'ytick', [1e-10 1e-8 1e-6 1e-4]);
s=sprintf('Slow/\nhot');
g = text(0.05, 5e-6, s);
set(g, 'fontsize', 9);
g = text(0.3, 1e-9, 'Fast/cold');
set(g, 'fontsize', 9, 'backgroundcolor', 'w');

subaxis(2,2,2);
grid;
set(gca,'YMinorGrid','off')
axis([0.6 1.2 1e-5 2e-3]);
xlabel({'{\itV_G_S}   (V)'; '(b)'});
ylabel('{\itJ_D}   (A/\mum)')
set(gca, 'ytick', [1e-5 1e-4 1e-3]);

subaxis(2,2,3);
grid;
axis([0 1.2 0 40]);
xlabel({'{\itV_G_S}   (V)'; '(c)'});
ylabel('{\itg_m}/{\itI_D}   (S/A)')
s=sprintf('Slow/\nhot');
g = text(0.05, 15, s);
set(g, 'fontsize', 9);
g = text(0.44, 37, 'Fast/cold');
set(g, 'fontsize', 9, 'backgroundcolor', 'w');

subaxis(2,2,4);
grid;
axis([0.6 1.2 0 10]);
xlabel({'{\itV_G_S}   (V)'; '(d)'});
ylabel('{\itg_m}/{\itI_D}   (S/A)')

%format_and_save(h, 'FigA1_6', 'W', 5.2, 'H', 5.2)




