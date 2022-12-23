function y = XTRACT(dev,L,VDS,VSB,rho)
% EKV param identification algor =====================================
% L, VSB are scalars
% VDS scalar or column vector
% rho reference        (optional scalar)

if nargin < 5, rho = .6; end


% rho = .6; dev = nch; VSB = 0; L = .1; VDS = (.1:.1:.8)';

% data ================ 
UT  = .0259*dev.TEMP/300;
UDS = (.025: .025: 1.2)';

%  find n(UDS) ==============
gm_ID = lookup(dev,'GM_ID','VDS',UDS,'VSB',VSB,'L',L);  
[a b] = max(gm_ID); 
M = a';
nn = 1./(M*UT);  

% find VT(UDS) ============
q  = 1/rho - 1;
i  = q^2 + q;
VP = UT*(2*(q-1) + log(q)); 

gmIDref = rho*M;
for k = 1:length(UDS),
    VGS(k,1) = interp1(gm_ID(:,k),dev.VGS,gmIDref(k),'pchip');
end
Vth = VGS - nn.*VP;

%find JS(UDS) ===============
Js = diag(lookup(dev,'ID_W','GM_ID',gmIDref,'VDS',UDS,'VSB',VSB,'L',L))/i; 




% DERIVATIVES ===============
UDS1 = .5*(UDS(1:end-1) + UDS(2:end));
UDS2 = .5*(UDS1(1:end-1) + UDS1(2:end));

diffUDS = diff(UDS);
diffUDS1 = diff(UDS1);

% subthreshold slope ============
diff1n = diff(nn)./diffUDS;
diff2n = diff(diff1n)./diffUDS1;

% threshold voltage =============
diff1Vth = diff(Vth)./diffUDS;
diff2Vth = diff(diff1Vth)./diffUDS1;

% log specific current ============
diff1logJs = diff(log(Js))./diffUDS;
diff2logJs = diff(diff1logJs)./diffUDS1;




% n(VDS), VT(VDS) , JS(VDS) ===========
n  = interp1(UDS,nn,VDS,'pchip'); 
VT = interp1(UDS,Vth,VDS,'pchip');
JS = interp1(UDS,Js,VDS,'pchip');

d1n = interp1(UDS1,diff1n,VDS,'pchip');
d2n = interp1(UDS2,diff2n,VDS,'pchip');

d1VT = interp1(UDS1,diff1Vth,VDS,'pchip');
d2VT = interp1(UDS2,diff2Vth,VDS,'pchip');

d1logJS = interp1(UDS1,diff1logJs,VDS,'pchip');
d2logJS = interp1(UDS2,diff2logJs,VDS,'pchip');

% OUTPUT ========
y = [VDS n VT JS d1n d1VT d1logJS d2n d2VT d2logJS]; 



return
% FIGURE =============
figure(1); plot(UDS,nn,VDS,n,'*'); grid
figure(2); plot(UDS1,diff1VT,VDS,d1VT,'*'); grid
figure(3); plot(UDS2,diff2VT,VDS,d2VT,'*'); grid; pause

figure(1); plot(UDS,nn,VDS,n,'*'); grid
figure(2); plot(UDS1,diff1n,VDS,d1n,'*'); grid
figure(3); plot(UDS2,diff2n,VDS,d2n,'*'); grid; pause

figure(1); plot(UDS,Js,VDS,JS,'*'); grid
figure(2); plot(UDS1,diff1logJs,VDS,d1logJS,'*'); grid
figure(3); plot(UDS2,diff2logJs,VDS,d2logJS,'*'); grid

% y = [VDS n VT JS d1n d1VT d1logJS d2n d2VT d2logJS];




