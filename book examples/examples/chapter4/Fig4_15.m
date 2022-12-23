% 4.2.1   compare real to EKV an/a1 over gm/ID^(n-1)
clear all;
close all;
addpath ../../lib

load 65nch.mat;

% data ==========================
L   = .1;
VGS = nch.VGS;
VDS = .6;
UGS = .5*(VGS(1:end-1) + VGS(2:end));

% real transistor --------------
id             = lookup(nch,'ID','VDS',VDS,'L',L);
id_prime       = lookup(nch,'GM','VDS',VDS,'L',L);
id_prime_prime = interp1(UGS,diff(id_prime)./diff(VGS),VGS,'cubic'); 
id_prime_prime_prime = interp1(UGS,diff(id_prime_prime)./diff(VGS),VGS,'cubic'); 

a2_a1 = id_prime_prime./id_prime;
a3_a1 = id_prime_prime_prime./id_prime;


gm_id = lookup(nch,'GM_ID','VDS',VDS,'L',L);
norm_a2_a1 = a2_a1./gm_id;
norm_a3_a1 = a3_a1./(gm_id).^2;


% EKV =============================
UT = .026;
y   = XTRACT(nch,L,VDS,0);  %XTRACT(nch,L,VDS,VBS,R)
n   = y(2);     %VTo = y(3); and JS  = y(4); not needed

q      = logspace(-3,2,50);
gmID   = 1./(n*UT*(1+q));
normY2 = (1 + q)./(1 + 2*q);         % (gm2/gm1)/gm/ID 
normY3 = (1 + q).^2./(1 + 2*q).^3;  % (gm3/gm1)/(gm/ID)^2 

% plot ========================
h = figure(1)
plot(gm_id(5:end), norm_a2_a1(5:end),'k',gm_id(5:40), norm_a3_a1(5:40),'k',...
    gmID,normY2,'K--',gmID,normY3,'K--','linewidth',1);
set(gca, 'fontsize', 12);
xlabel('{\itg_m}/{\itI_D}  (S/A)');
ylabel('(V), (V^-^1)')
axis([0 32 -.4 1.2])
text(11,.78,'{\itk} = 2'); text(12,0.3,'{\itk} = 3');
text(3,1,'{\it(g_m_k}/{\itg_m_1})/({\itg_m}/{\itI_D)^(^k^-^1^)}')
grid;

%format_and_save(h, 'Fig4_15')