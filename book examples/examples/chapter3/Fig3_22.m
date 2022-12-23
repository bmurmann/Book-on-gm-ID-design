% Example 3.7   convergence self loading option(b) Table 3.1, 3.2 and 3.3
clear all
close all
addpath ../../lib
load 65nch.mat
load 65pch.mat

% data Table(3.1) ==========================
fu = 1e9;       % (Hz)
CL = 1e-12;     % (F)

gmID1 = 20.76;  % (S/A)
L1 = .07;       % (µm)


% size IGS ====================== 
JD    = lookup(nch,'ID_W','GM_ID',gmID1,'L',L1);  
Cdd_W = lookup(nch,'CDD_W','GM_ID',gmID1,'L',L1);

Cdd  = 0;
wu   = 2*pi*fu;
Iter = 1:8
for m = Iter,
    gm(m,1) = wu*(CL + Cdd);
    ID(m,1) = gm(m,1)/gmID1; 
    W1(m,1) = ID(m,1)./JD;
    Cdd = W1(m,1)*Cdd_W; Cdd1(m,1) = Cdd;
end


% plot ===================
h = figure(1),
plot(Iter,1e6*ID,'ko-','linewidth',1); 
grid; 
xlabel('Iteration'); 
ylabel('{\itI_D}  (µA)')
axis([1 5 300 330])
    
% verif factor S ==================
Cddo = Cdd1(1);
S = 1/(1 - Cddo/CL)
IDs = S*ID(1)
W1s = S*W1(1)

%format_and_save(h, 'Fig3_22')
