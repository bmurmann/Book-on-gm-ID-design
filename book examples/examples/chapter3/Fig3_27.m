% 3.2.2   Active load: R loaded CS stage
clear all
close all
addpath ../../lib
load 65nch.mat


% data ==========================
VDD = 1.2;              % (V)
L   = [.1 .2 .5 1];     % (µm)      
UDS = .1*(.5:.2:12)';   % (V)        
gm_ID = [5 20];         % (S/A)

% compute ==================
zL = length(L);
zV = length(UDS);

for m = 1:2,
    gmID = gm_ID(m);
    for k = 1:zL,
        gdsID(:,k) = lookup(nch,'GDS_ID','GM_ID',gmID,'VDS',UDS,'L',L(k));
    end
    Avo(:,:,m) = gmID./gdsID;
    Avr(:,:,m) = gmID./(gdsID + 1./(VDD-UDS(:,ones(1,length(L)))));
    [a b] = max(Avr(:,:,m)); 
    Avrmax(m,:) = a;
    VDSmax(m,:) = UDS(b);
end

% plot ==========================
h = figure(1)

subaxis(1,2,1,'Spacing', 0.05, 'MarginBottom', 0.2, 'MarginTop', 0.08, 'MarginLeft', 0.1, 'MarginRight', 0.03); 
plot(UDS, (VDD-UDS)*gm_ID(1), 'k--', 'linewidth', 1)
hold;
plot(UDS,Avr(:,:,1),'k',VDSmax(1,:),Avrmax(1,:),'ko',.6*[1 1],[0 100],'k:', 'linewidth', 1)
xlabel({'{\itV_D_S_1}  (V)'; '(a)'}); ylabel('|{\itA_v_0}|');
axis([0 VDD 0 17]);
k = title('{\itg_m}/{\itI_D} = 5 (S/A)')
set(k, 'fontweight', 'normal', 'fontsize', 9);
grid
legend('(3.14)', '(3.13)', 'location', 'northeast')

subaxis(1,2,2);
plot(UDS, (VDD-UDS)*gm_ID(2), 'k--', 'linewidth', 1)
hold
plot(UDS,Avr(:,:,2),'k',VDSmax(2,:),Avrmax(2,:),'ko',.6*[1 1],[0 100],'k:', 'linewidth', 1)
xlabel({'{\itV_D_S_1}  (V)'; '(b)'}); 
axis([0 VDD 0 17]);
k = title('{\itg_m}/{\itI_D} = 20 (S/A)', 'fontsize', 9);
set(k, 'fontweight', 'normal', 'fontsize', 9);
grid

%format_and_save(h, 'Fig3_27', 'W', 5.3)

