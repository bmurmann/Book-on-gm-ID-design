% Example 2.3   compare EKV reconstructed ID to real
clear all;
close all;
addpath ../../lib
load 65nch.mat;

% data ================
UDS = (.6: .3: 1.2)';
VBS = 0;


% A) ==================
L   = .06;
    % real transistor --------------
Id1  = lookup(nch,'ID','VDS',UDS,'L',L);
Vgs = nch.VGS;

% y2 = XTRACT2(Vgs,Id1); compare to n1, VT1, IS1 below.

% EKV model -------
UT = .026;
N = 20; 
q  = logspace(-5,1.1,N)';
i  = q.^2 + q;
VP = UT*(2*(q-1) + log(q));

y1  = XTRACT(nch,L,UDS,VBS); 
n1  = y1(:,2)';
VT1 = y1(:,3)';
IS1 = 10*y1(:,4)';
ID1 = i*IS1;
VG1 = VP*n1 + VT1(ones(N,1),:);


% B) =====================
L = .1;
    % real transistor ---------
Id2 = lookup(nch,'ID','VDS',UDS,'L',L);

    % EKV model -------
y3  = XTRACT(nch,L,UDS,VBS); %xtract1(ID(:,k),VGS)  
n3  = y3(:,2)';
VT3 = y3(:,3)';
IS3 = 10*y3(:,4)';
ID3 = i*IS3;
VG3 = VP*n3 + VT3(ones(N,1),:);


% C) ==========================
L = .5;
% real transistor ---------
Id3 = lookup(nch,'ID','VDS',UDS,'L',L);

% EKV model -------
y2  = XTRACT(nch,L,UDS,VBS); %xtract1(ID(:,k),VGS)  
n2  = y2 (:,2)';
VT2 = y2(:,3)';
IS2 = 10*y2(:,4)';
ID2 = i*IS2;
VG2= VP*n2 + VT2(ones(N,1),:);


% plot ========================

h1 = figure(1);
subaxis(2,1,1,'Spacing', 0.12, 'MarginBottom', 0.12, 'MarginTop', 0.03, 'MarginLeft', 0.20, 'MarginRight', 0.03); 
semilogy(Vgs,Id1(:,1),'k--',Vgs,Id2(:,1),'k-',Vgs,Id3(:,1),'k.-','linewidth',1); 
axis([0 1.2 0 .01]); grid; hold
semilogy(Vgs,Id1(:,2:end),'k--',Vgs,Id2(:,2:end),'k-',Vgs,Id3(:,2:end),'k.-','linewidth',1); 
semilogy(VG1,ID1,'k+',VG2,ID2,'k+',VG3,ID3,'k+','linewidth', 1.01); 
xlabel({'{\itV_G_S}  (V)'; '(a)'}); 
ylabel('{\itI_D}  (A)');
legend('{\itL}= 60 nm','{\itL}= 100 nm','{\itL}= 500 nm','location', 'southeast')
hold

M = 150; q  = logspace(-5,1.1,M)';
i  = q.^2 + q;
VP = UT*(2*(q-1) + log(q));
ID1 = i*IS1;
VG1 = VP*n1 + VT1(ones(M,1),:);
subaxis(2,1,2);
plot(Vgs,Id1,'k--',VG1,ID1,'k+','linewidth', 1.01);
axis([0 1.2 0 .01]); grid 
xlabel({'{\itV_G_S}  (V)'; '(b)'}); 
ylabel('{\itI_D}  (A)')
text(.75,.6e-2,'{\itL} = 60 nm', 'fontsize', 9); 

%format_and_save(h1, 'Fig2_13', 'H',5.5)
