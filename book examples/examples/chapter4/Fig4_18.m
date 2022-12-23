%  derivatives of diffpair
clearvars;
close all
addpath ../../lib
load 65nch.mat

% diff ibput voltage ===========
ViD = -.15: .005: .15;   

% data real transistor ============
L = 0.1;
gm_ID = [27 15];                    
VGB = 0.8 ;
VDB = 0.8;

% compute ===============
VGSo = lookupVGS(nch,'GM_ID',gm_ID,'VDB',VDB,'VGB',VGB,'L',L)
VSBo = VGB - VGSo
VDSo = VDB - VSBo
%J0 = lookup(nch,'ID_W','GM_ID',gm_ID,'VGB',VDB,'VGB',VGB,'L',L)
J0 = diag(lookup(nch,'ID_W','GM_ID',gm_ID,'VDS',VDSo,'VSB',VSBo,'L',L))

% EKV ================
UT = .026;
vg = .5*(ViD(1:end-1) + ViD(2:end));
m  = (.01:.005:1.99); 
b  = find(m==1);

for k = 1:length(gm_ID),
    JD = lookup(nch,'ID_W','VGS',nch.VGS,'VDS',VDSo(k),'VSB',VSBo(k),'L',L);

    y  = XTRACT2(nch.VGS,JD,.5);
    n  = y(1)
    JS = y(3)
    
        io  = 2*J0(k)/JS; % norm tail current
        i2  = .5*io*m;
        q2  = .5*(sqrt(1+4*i2)-1); 
        q1  = .5*(-1 + sqrt(1 + 4*(io-q2.^2-q2)));
        DVG = n*UT*(2*(q2-q1) + log(q2./q1));
        
        i = 2*interp1(DVG,i2,ViD,'spline') - io; 
        I(k,:) = i/io;
        
        % === NUMERICAL evaluation of EKV derivatives 
        gm1(k,:) = interp1(vg,diff(i*JS)./diff(ViD),ViD,'spline'); 
        gm2(k,:) = interp1(vg,diff(gm1(k,:))./diff(ViD),ViD,'cubic'); 
        gm3(k,:) = interp1(vg,diff(gm2(k,:))./diff(ViD),ViD,'cubic'); 
        
 
% ANALYTICAL evaluation of mid-points
    q   = q2(b);      	% adress VG = 0
    rho = 1/(1+q);      % normalized gm/ID
    ao(k,1)  = 0;
    a1(k,1)  = JS/(n*UT)*q;
    a2(k,1)  = 0;
    a3(k,1)  = -.5*JS/(n*UT)^3*q.*(1+3*q)./(1+2*q).^3;
end

% plot
h = figure(1);
subaxis(4,2,1,'Spacing', 0.07, 'MarginBottom', 0.08, 'MarginTop', 0.04, 'MarginLeft', 0.09, 'MarginRight', 0.02); 
plot(ViD,I(1,:),'k',0,0,'ko'); hold;
axis([min(ViD) max(ViD) -1 1]); grid; ylabel('{\iti_o_d}/{\itI_0}');
g = title('{\itg_m}/{\itI_D} = 27 S/A');
set(g, 'fontsize', 9, 'fontweight', 'normal');
xlabel('(a)');

subaxis(4,2,2); plot (ViD,I(2,:),'k',0,0,'ko'); hold;
axis([min(ViD) max(ViD) -1 1]); grid;
g = title('{\itg_m}/{\itI_D} = 15 S/A');
set(g, 'fontsize', 9, 'fontweight', 'normal');
xlabel('(b)');

subaxis(4,2,3); 
plot (ViD,gm1(1,:),'k',0,a1(1),'ko'); hold; ylabel('{\itg_m_1}  (S)','fontsize',9);
axis([min(ViD) max(ViD) 0 2e-5]); grid 
xlabel('(c)');

subaxis(4,2,4); plot (ViD,gm1(2,:),'k',0,a1(2),'ko'); hold; 
axis([min(ViD) max(ViD) 0 1.5e-4]); grid 
xlabel('(d)');

subaxis(4,2,5); plot (ViD,gm2(1,:),'k',0,a2(1),'ko'); hold; ylabel('{\itg_m_2}  (S/V)','fontsize',9);
axis([min(ViD) max(ViD) -2e-4 2e-4]); grid 
xlabel('(e)');

subaxis(4,2,6); plot (ViD,gm2(2,:),'k',0,a2(2),'ko'); hold; 
axis([min(ViD) max(ViD) -1e-3 1e-3]); grid 
xlabel('(f)');

subaxis(4,2,7); plot (ViD,gm3(1,:),'k',0,a3(1),'ko'); hold; ylabel('{\itg_m_3}  (S/V^2)','fontsize',9);
axis([min(ViD) max(ViD) -6e-3 3e-3]); grid 
xlabel({'{\itv_i_d}  (V)';'(g)'});

subaxis(4,2,8); plot (ViD,gm3(2,:),'k',0,a3(2),'ko'); hold; 
axis([min(ViD) max(ViD) -1e-2 5e-3]); grid
xlabel({'{\itv_i_d}  (V)';'(h)'});


% Load and plot Spice data
load('Fig4_18.mat')
iod_wi_norm = iod_wi/11.3e-6;
iod_mi_norm = iod_mi/176.9e-6;

% === NUMERICAL evaluation of derivatives 
vid = .5*(vid_wi(1:end-1) + vid_wi(2:end));
gm1_wi = interp1(vid,diff(iod_wi)./diff(vid_wi),vid_wi)/10; 
gm2_wi = interp1(vid,diff(gm1_wi)./diff(vid_wi),vid_wi); 
gm3_wi = interp1(vid,diff(gm2_wi)./diff(vid_wi),vid_wi);

vid = .5*(vid_mi(1:end-1) + vid_mi(2:end));
gm1_mi = interp1(vid,diff(iod_mi)./diff(vid_mi),vid_mi)/10; 
gm2_mi = interp1(vid,diff(gm1_mi)./diff(vid_mi),vid_mi); 
gm3_mi = interp1(vid,diff(gm2_mi)./diff(vid_mi),vid_mi);

k = 1:10:length(vid_wi);
subaxis(4,2,1)
plot(vid_wi(k), iod_wi_norm(k), 'k+', 'linewidth', 1.05);
subaxis(4,2,3)
plot(vid_wi(k), gm1_wi(k), 'k+', 'linewidth', 1.05);
subaxis(4,2,5)
plot(vid_wi(k), gm2_wi(k), 'k+', 'linewidth', 1.05);
subaxis(4,2,7)
plot(vid_wi(k), gm3_wi(k), 'k+', 'linewidth', 1.05);

k = 1:10:length(vid_mi);
subaxis(4,2,2)
plot(vid_mi(k), iod_mi_norm(k), 'k+', 'linewidth', 1.05);
subaxis(4,2,4)
plot(vid_mi(k), gm1_mi(k), 'k+', 'linewidth', 1.05);
subaxis(4,2,6)
plot(vid_mi(k), gm2_mi(k), 'k+', 'linewidth', 1.05);
subaxis(4,2,8)
plot(vid_mi(k), gm3_mi(k), 'k+', 'linewidth', 1.05);

%format_and_save(h, 'Fig4_18', 'W', 5.3, 'H', 7.5)

