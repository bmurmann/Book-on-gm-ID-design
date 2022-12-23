% 2.3.7   low frequency intrinsic gain versus gm/ID, paral L
% plain = real; dashed = EKV
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat                                      

% data ==================
q   = logspace(-2,1,20)';   % param 
LL  = [.06 .1 .2 .5]; % micron   
VDS = .6;  % Volt
VSB = 0;  % Volt


% 1 ==============================================
dev = nch;
% == EKV model ===============                        
UT = .026;
for k = 1:length(LL),
    L    = LL(k);
    Y    = XTRACT(dev,L,VDS,VSB);                 
    
    S_VT = Y(6);
    S_IS = Y(7);
    n    = Y(2);
     
    gm_ID(:,k) = 1./(n*UT*(q + 1));
    AEKV(:,k)  = 20*log10(1./(-S_VT + S_IS./gm_ID(:,k)));
    
end

% == 'real' transistor ========                  
UG = .3:.025:.7;
gm_ID1 = lookup(dev,'GM_ID','VGS',UG,'VDS',VDS,'VSB',VSB,'L',LL);    
A = 20*log10(lookup(dev,'GM_GDS','VGS',UG,'VDS',VDS,'VSB',VSB,'L',LL));

% plot ==========================
h = figure(1);
plot(gm_ID,AEKV,'k--',gm_ID1',A','k','linewidth',1); grid; axis([0 30 0 50]);
xlabel('{\itg_m}/{\itI_D}  (S/A)'); 
ylabel('{\itA_i_n_t_r}  (dB)');
text(20,23,'60 nm', 'fontsize', 9);
text(20,31,'100 nm', 'fontsize', 9);
text(20,38,'200 nm', 'fontsize', 9);
text(17,45,'{\itL} = 500 nm', 'fontsize', 9);


%format_and_save(h, 'Fig2_25')


