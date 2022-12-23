% A.1.6   Table A.1.4
clear all
close all
addpath ../../lib

files = {'65pch_slow_hot.mat', '65pch.mat', '65pch_fast_cold.mat'}; 


% data =============
VDS = .6;   
VBS = .0;      
L   = .1;
rho = .6;

% Table A.1.4 =============
for k = 1:length(files)
    load(files{k});
    y(k,:) = XTRACT(pch,L,VDS,VBS,rho);
    Temp(k,1) = pch.TEMP;               % needed for reconstr
    JD(:,k) = lookup(pch,'ID_W','L',L); % needed for reconstr    
end

n  = y(:,2);
VT = y(:,3);
JS = y(:,4);

UT = .0259*Temp/300;
beta = JS./(2*n.*UT.^2);

Data_A_1_4 = [Temp'; n'; VT'; JS'*1e6; beta'*1e3] 

