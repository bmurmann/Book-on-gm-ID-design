% 5.3   R of series LDO versus regulated voltage V
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


% plot r =================
h2 = figure(2); 
plot(VDD-Vdropout_p,rp,'k','linewidth',1);
text(.55,1.06*rp(31,1),'20 S/A ', 'fontsize', 9)
text(.55,1.08*rp(31,2),'15 ', 'fontsize', 9)
text(.55,1.1*rp(31,3),'10', 'fontsize', 9)
text(.55,.83*rp(31,4),' 5', 'fontsize', 9)
grid; 
axis([.4 1.2+eps 0 200]);
ylabel('1/{\itg_d_s}  (\Omega)'); 
xlabel('{\itV_O_U_T}  (V)');

%format_and_save(h2, 'Fig5_12')