% 5.3   W of series LDO versus regulated voltage V
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat  

% data =======================
VDD = 1.2;          % supply voltage     
I   = 10e-3;        % desired load current
L   = .06;           % gate length
gmIDp = 5*[1:4];         % parameter


% 1) n-channel com drain  (Wn is min when gate is connected to VDD)
VSB = .4: .02: .8; zn = length(VSB);
Vdropout_n = VDD - VSB;                 % Vdropout_n = VGS = VDS
IDn = lookup(nch,'ID_W','VGS',Vdropout_n,'VDS',Vdropout_n,'VSB',VSB,'L',L*ones(1,zn));    
Wn  = I./IDn;

% 2) p-channel CS ===============
Vdropout_p   = .05: .02: .8;            % Vdropout_p = VDS    
IDp  = lookup(pch,'ID_W','GM_ID',gmIDp,'VDS',Vdropout_p,'VSB',0,'L',L);
Wp   = I./IDp;
rp   = 1./(Wp.*lookup(pch,'GDS_W','GM_ID',gmIDp,'VDS',Vdropout_p,'L',L));


% plot W =======================
h1 = figure(1); 
semilogy(VSB,Wn,'k--',VDD-Vdropout_p,Wp,'k','linewidth',1);
grid; axis([.4 1.2+eps 50 5e4]);
text(.83,.75*Wp(17,1),'5  S/A ', 'fontsize', 9)
text(.83,.75*Wp(17,2),'10 ', 'fontsize', 9)
text(.83,.75*Wp(17,3),'15 ', 'fontsize', 9)
text(.83,.75*Wp(17,4),'20', 'fontsize', 9)
ylabel('{\itW}  (\mum)');
xlabel('{\itV_O_U_T}  (V)');
set(gca, 'yminorgrid', 'off');
  
%format_and_save(h1, 'Fig5_11')

