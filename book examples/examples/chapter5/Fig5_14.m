%Example 5.2   LDO's loop gain versus gm/ID's      
clear all
close all
addpath ../../lib
load 65nch.mat                                      
load 65pch.mat  

% data =======================
VDD = 1.2;         % supply voltage     
V   = .9;          % desired regulated voltage
I   = .01;         % desired output current 
LL  = [.1 .2]; 
Lp  = .5;
Ln  = .5;


% pch series transistor M (vertical) pas d'indice ======================
gm_ID = (8:1:12)'; zp = length(gm_ID);
US = .2: .02: .5; zn = length(US);

VDS = VDD - V;
for m = 1:length(LL),
    L = LL(m);
    Id  = lookup(pch,'ID_W','GM_ID',gm_ID,'VDS',VDS,'L',L);
    gds_ID = lookup(pch,'GDS_ID','GM_ID',gm_ID,'VDS',VDS,'L',L);
    A = gm_ID./(1/V + gds_ID);

    W   = I./Id;
    VGS = lookupVGS(pch,'GM_ID',gm_ID,'VDS',VDS,'L',L);
    VD  = VDD - VGS; 


    % current mirror =================
    gds_IDp = diag(lookup(pch,'GDS_ID','VGS',VGS,'VDS',VGS,'L',Lp));


    % diff pair (horizontal) ======================
    for k = 1:zn
        VS = US(k);
        gm_IDn(:,k)  = lookup(nch,'GM_ID','VGS',V-VS,'VDS',VD-VS,'VSB',VS,'L',Ln);
        gds_IDn(:,k) = lookup(nch,'GDS_ID','VGS',V-VS,'VDS',VD-VS,'VSB',VS,'L',Ln);
    end
    Aa = gm_IDn./(gds_IDn + gds_IDp(:,ones(1,zn)));
    gain(:,:,m) = Aa.*A(:,ones(1,zn));
end


h = figure(1);
subaxis(1,2,1,'Spacing', 0.11, 'MarginBottom', 0.17, 'MarginTop', 0.06, 'MarginLeft', 0.11, 'MarginRight', 0.03); 
plot(gm_IDn',gain(:,:,1)','k','linewidth',1); 
ylabel('{\itA_1\cdotA_a}');
xlabel({'({\itg_m}/{\itI_D)_n}  (S/A)';'(a)'}) 
text(7,30,'({\itg_m}/{\itI_D})_1 = 8 S/A', 'fontsize', 9);
text(12,170,'12 S/A', 'fontsize', 9);
t = title('{\itL_1} = 100 nm', 'fontsize', 9);
set(t, 'fontweight', 'normal', 'fontsize', 9);
axis([5 30 0 220]); grid

subaxis(1,2,2); plot(gm_IDn',gain(:,:,2)','k','linewidth',1); 
ylabel('{\itA_1\cdotA_a}');
xlabel({'({\itg_m}/{\itI_D)_n}  (S/A)';'(b)'}) 
text(8,50,'({\itg_m}/{\itI_D})_1 = 8 S/A', 'fontsize', 9);
text(8,170,'12 S/A', 'fontsize', 9);
t = title('{\itL_1} = 200 nm', 'fontsize', 9);
set(t, 'fontweight', 'normal', 'fontsize', 9);
axis([5 30 0 220]); grid

%format_and_save(h, 'Fig5_14', 'W', 5.3, 'H', 3.5)




