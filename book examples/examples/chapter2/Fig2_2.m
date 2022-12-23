% Example 2.1   CSM surface potential psis
clear all;
close all
addpath ../../lib

% data techno --------------------------
T   = 300;                    	% temperature °K
N   = 1e17;                    	% doping conc. cm^-3
tox = 5;                        % oxide thickness nm

VS  = 0;                       	% source voltage V
VG  = 1.5: .5: 3;             	% gate voltage V
V   = linspace(0,2.5,20)';      % non-equilbr. voltage V


% compute pMat (see annex A2.1.1) --------------------- 
p = pMat(T,N,tox);
UT = p(3,1); gam = p(2,1); K = p(4,1); phiB = p(1,1);

for k = 1:length(VG),
    % inverted Gauss equation
    Ymax(k,1) = (sqrt((gam/2)^2+VG(k))-gam/2).^2;
    X(:,k) = Ymax(k,1) - 10.^(-10:.1:0.5); 
    Y(:,k) = - UT*log((((VG(k)-X(:,k))/gam).^2-X(:,k))/UT) + X(:,k) - 2*phiB;
    % with the surfpot function.
    psis(:,k) = surfpot(p,V,VG(k));
end

% plot ===================================
h = figure(1);
plot(Y, X, 'k', V, psis,'kx', 'linewidth', 1.05); 
axis([0 2.5 0 3]); grid

for k = 1:length(VG)-1,
    g = text(max(Y(:,k))-.1,Ymax(k,1)+.18,sprintf('%0.1f',VG(k)))
    set(g, 'fontsize', 9);
    g = text(max(Y(:,k))+.1,Ymax(k,1)+.18,'V')
    set(g, 'fontsize', 9);
    
end
g = text(1.6,Ymax(length(VG))+.18,'{\itV_G} = 3.0 V', 'fontsize', 9);
xlabel('{\itV}  (V)'); ylabel('{\it\psi_S}  (V)');

%format_and_save(h,'Fig2_02');  