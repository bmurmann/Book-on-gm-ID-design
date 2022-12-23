function y = XTRACT2(VGS,ID,rho)
% extracts n, VT, IS from ID(VGS)
% VGS column vector
% ID column vector or matrix ID(VGS,VDS)
% rho = normalized (gm/ID) reference
% Temp = 300°K

    % TEST
    %clear all; close all; addpath ../../lib; load 65nch.mat;
    %VDS = (.3: .05: 1)'; VSB = .0; L   = .1; rho   = .6;
    %ID    = lookup(nch, 'ID_W', 'VDS', VDS, 'VSB', VSB, 'L',L);    
    %VGS   = (nch.VGS);

if nargin < 3, rho = 0.6; end

% compute ===================
qFo = 1/rho - 1;
i  = qFo.^2 + qFo;

UT = .026;
[m1 m2] = size(ID);         % Id(VGS,VDS)

% compute max(gm/ID) ---------
gm_Id = diff(log(ID))./diff(VGS(:,ones(1,m2)));
[z1 b] = max(gm_Id);


% compute VGSo and IDo -------
UGS     = .5*(VGS(1:m1-1) + VGS(2:m1));
for k = 1:m2,
    VGSo(k,1) = interp1(gm_Id(:,k),UGS,z1(k)*rho,'cubic');
    IDo(k,1)  = interp1(VGS,ID(:,k),VGSo(k,1),'cubic');
end

n  = 1./(UT*z1');
VT = VGSo - UT*n.*(2*(qFo-1)+log(qFo));
IS = IDo/i;

y = [n VT IS]; 


