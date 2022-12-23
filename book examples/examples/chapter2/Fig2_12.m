% 2.3.1   real ID(VGS) characteristics
clear all;
close all;
addpath ../../lib

load 65nch.mat;

% data ----------------------
%T = 300;
L = [0.06 .1 .5];
Vds = .6: .3: 1.2;


for k = 1:length(L),
    Id(:,:,k) = lookup(nch, 'ID', 'VDS', Vds, 'L', L(k)); % Id(Vgs,Vds,L)
end

% plot ----------
h = figure; 
semilogy(nch.VGS,Id(:,1,1),'k--','linewidth',1); 
hold on;
semilogy(nch.VGS,Id(:,1,2),'k-','linewidth',1);
semilogy(nch.VGS,Id(:,1,3),'k.-','linewidth',1);

legend('{\itL}= 60 nm','{\itL}= 100 nm','{\itL}= 500 nm','location', 'southeast')

semilogy(nch.VGS,Id(:,2:3,1),'k--','linewidth',1); 
semilogy(nch.VGS,Id(:,2:3,2),'k-','linewidth',1);
semilogy(nch.VGS,Id(:,2:3,3),'k.-','linewidth',1);

axis([0 1.2 1e-12 1e-2]); grid
xlabel('{\itV_G_S}_      (V)'); ylabel('{\itI_D}     (A)');
set(gca,'xtick', 0:.2:1.2)

%format_and_save(h, 'Fig2_12')


