% 5.2.2   four transistor current mirror Iout and rout
clear all
close all
addpath ../../lib
load 65nch.mat

% data =================
L     = .5;
IDo   = 1e-4;
gmID1 = 20;
%VDS2  = (.09:.025:1)'; 


% 1) current mirror ===================
Vx  = [0 0.05 .1]';     zD = length(Vx);   	
VDS1 = 2/gmID1 + Vx;
S   = .001*(0:50);  % used by interp1 making JD1 = JD2 


for k = 1:zD,
    UDS1 = VDS1(k); 
  % M1 ========
    UGS1 = lookupVGS(nch,'GM_ID',gmID1,'VDS',UDS1,'L',L); 
    JD1  = lookup(nch,'ID_W','VGS',UGS1,'VDS',UDS1,'L',L);
   	VGS1(k,1) = UGS1;
    W1(k,1)   = IDo/JD1;

  % M2 ========
  	JD2  = lookup(nch,'ID_W','VGS',UGS1+S,'VDS',UGS1-UDS1,'VSB',UDS1,'L',L);
    UGS2 = interp1(JD2/JD1,UGS1+S,1);   % M1 and M2 same widths
    VGS2(k,1)  = UGS2;
    gmID2(k,1) = lookup(nch,'GM_ID','VGS',UGS2,'VDS',UGS1-UDS1,'VSB',UDS1,'L',L);  
    
  % output Early voltage ===============
    VEA1(k,1) = lookup(nch,'ID_GDS','VGS',UGS1,'VDS',UDS1,'L',L); 
    gm4_ID  = lookup(nch,'GM_ID','VGS',UGS2,'VDS',UGS1-UDS1,'VSB',UDS1,'L',L);
    gmb4_ID = lookup(nch,'GMB_ID','VGS',UGS2,'VDS',UGS1-UDS1,'VSB',UDS1,'L',L);
    gds4_ID = lookup(nch,'GDS_ID','VGS',UGS2,'VDS',UGS1-UDS1,'VSB',UDS1,'L',L);
    A4(k,1) = (gm4_ID + gmb4_ID + gds4_ID + 1/VEA1(k,1))/gds4_ID; 
end

%VEA1
%A4
%VEA1.*A4

Vbias = VDS1 + VGS2;
%VV = [VGS1 VDS1 VGS2 Vbias gmID2]


% 2) bias circuitry ===================
for k = 1:3,
    JD6(k,1) = lookup(nch,'ID_W','VGS',VGS2(k),'VDS',VGS2(k),'VSB',VDS1(k),'L',L);
    ID6(k,1) = W1(k)*JD6(k,1);
    JD7 = lookup(nch,'ID_W','VGS',Vbias(k),'VDS',VDS1(k),'L',L);
    W7(k,1) = ID6(k,1)/JD7;
end


% output current ================
VDS2  = (.1:.050:1.1)'; 

zV = length(VDS2); 
x    = .03*(-3:4)'; zx = length(x);      % VDS3 node search
for h = 1:3,
    Jd1 = lookup(nch,'ID_W','VGS',VGS1(h),'VDS',VDS1(h)+x,'L',L);
    for k = 1:zV,
        Jd2 = diag(lookup(nch,'ID_W','VGS',VGS2(h)-x,'VDS',VDS2(k),'VSB',VDS1(h)+x,'L',L));    
        Iout(k,h) = W1(h,1)*interp1(Jd2./Jd1,Jd1,1,'cubic');
        UDS1(k,h) = interp1(Jd2./Jd1,VDS1(h)+x,1,'cubic');
    end
end
Vout = UDS1 + VDS2(:,ones(1,3));        % [VDS2 UDS1]

for k = 1:3,
    Iref(1,k) = interp1(Vout(:,k),Iout(:,k),.6,'cubic');
end
i = Iout./Iref(ones(zV,1),:);

% Load Spice data
load('Fig5_9.mat');

% display bias voltages
vbias0 = vbias_0(1);
vbias50 = vbias_50(1);
vbias100 = vbias_100(1);

x =121;
h = figure(1);
subaxis(2,1,1,'Spacing', 0.14, 'MarginBottom', 0.14, 'MarginTop', 0.04, 'MarginLeft', 0.15, 'MarginRight', 0.03); 
plot(vout,iout_0/iout_0(x),'k--', 'linewidth',1);
hold;
plot(vout,iout_50/iout_50(x),'k-', 'linewidth',2);
plot(vout,iout_100/iout_100(x),'k-', Vout,i,'ok','linewidth',1, 'markersize', 4, 'markerfacecolor', 'w');
grid;
axis([0 1.2 .98 1.01]); 
legend('{\itV_X} = 0 mV', '{\itV_X} = 50 mV', '{\itV_X} = 100 mV', 'location', 'southeast')
ylabel('{\itI_O_U_T}/{\itI_R_E_F}');
xlabel({'{\itV_O_U_T}  (V)';'(a)'});

% output resistance ===========================
Uout = .5*(Vout(1:zV-1,:) + Vout(2:zV,:));
RR   = diff(Vout)./diff(Iout);

rout_0 = diff(vout)./diff(iout_0);
rout_50 = diff(vout)./diff(iout_50);
rout_100 = diff(vout)./diff(iout_100);

subaxis(2,1,2)
plot(vout(2:end),rout_0,'k--','linewidth',1)
hold on;
plot(vout(2:end),rout_50,'k-', 'linewidth',2)
plot(vout(2:end),rout_100, 'k-', Uout,RR,'ko','linewidth',1, 'markersize', 4, 'markerfacecolor', 'w')
axis([0 1.2 0 4.5e6]); grid
ylabel('{\itR_o_u_t}  (\Omega)'); xlabel({'{\itV_O_U_T}  (V)';'(b)'});

%format_and_save(h, 'Fig5_9', 'H', 4.5)



