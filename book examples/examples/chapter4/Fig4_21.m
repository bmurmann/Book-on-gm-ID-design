% Example 4.4   Size diffpair at given HD3 versus vid_pk 
clear all
close all
addpath ../../lib
load 65nch.mat

% data ====================
gm = 2/200;
L  = 0.1;
UT = .026; 
n  = 1/UT/max(lookup(nch,'GM_ID','L', L))


% compute =======================
q   = logspace(-2,1,100)';
vid = 10e-3 : 1e-3 : 40e-3;

HD3o = -60;
for k = 1:length(vid);    
    HD3 = 20*log10(1/24*1/(n*UT)^2*(1+3*q)./(2*(1+2*q).^3)*vid(k)^2);
    qo  = interp1(HD3,q,HD3o);
    gmIDa(k) = 1./(n*UT*(1+qo));
    ID = gm/gmIDa(k);
    I0a(k) = 2*ID;
    Wa(k) = ID/lookup(nch, 'ID_W', 'GM_ID', gmIDa(k), 'L', L);
end

HD3o = -70;
for k = 1:length(vid);
    HD3 = 20*log10(1/24*1/(n*UT)^2*(1+3*q)./(2*(1+2*q).^3)*vid(k)^2);
    qo  = interp1(HD3,q,HD3o);
    if isnan(qo)
        qo=0;
    end    
    gmIDb(k) = 1./(n*UT*(1+qo));
    ID = gm/gmIDb(k);
    I0b(k) = 2*ID;
    Wb(k) = ID/lookup(nch, 'ID_W', 'GM_ID', gmIDb(k), 'L', L);
end


% plot ===========================
h = figure(1);
subaxis(2,1,1,'Spacing', 0.15, 'MarginBottom', 0.15, 'MarginTop', 0.03, 'MarginLeft', 0.13, 'MarginRight', 0.03); 
plot(vid, I0a*1e3, 'k-', vid, I0b*1e3, 'k--', 'linewidth', 1)
xlabel({'{\itv_i_d_,_p_k}  (V)';'(a)'})
ylabel('{\itI_0}  (mA)')
axis([0.01 0.04 0 5])
grid;
subaxis(2,1,2)
plot(vid, Wa, 'k-', vid, Wb, 'k--', 'linewidth', 1)
xlabel({'{\itv_i_d_,_p_k}  (V)';'(b)'})
ylabel('{\itW}  (\mum)')
axis([0.01 0.04 0 200])
grid;

%format_and_save(h, 'Fig4_21', 'H', 4);

% for simulation:
I0 = 1e3*[I0a(1) I0a(end) I0b(1) I0b(end)]
W = [Wa(1) Wa(end) Wb(1) Wb(end)]
gmID = [gmIDa(1) gmIDa(end) gmIDb(1) gmIDb(end)]