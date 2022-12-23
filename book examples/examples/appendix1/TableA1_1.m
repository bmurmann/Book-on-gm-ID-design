% A.1.6   Table A.1.1
clear all
close all
addpath ../../lib

files = {'65nch_slow.mat', '65nch.mat', '65nch_fast.mat'}; 

% data =============
VDS = .6;   
VBS = .0;      
L   = .1;
rho = .6;

% Table A.1.1 =============
for k = 1:length(files)
    load(files{k});
    y(k,:) = XTRACT(nch,L,VDS,VBS,rho);
    Temp(k,1) = nch.TEMP;               % needed for reconstr
    JD(:,k) = lookup(nch,'ID_W','L',L); % needed for reconstr    
end

n  = y(:,2);
VT = y(:,3);
JS = y(:,4);

UT = .0259*Temp/300;
beta = JS./(2*n.*UT.^2);

Data_A_1_1 = [Temp'; n'; VT'; JS'*1e6; beta'*1e3] 


