% Example 4.2   output dynamic range
clear all
close all
addpath ../../lib


% data ====================
VDD = [.9 1.2];
x1 = 5*(1:5);           % (gm/ID)1
x2 = (3:.2:28)';        % (gm/ID)2

% 1 ==============
for k = 1:2,
    K = (VDD(k) - 2./7 - 2./x2).^2./(1 + x2./7);
    [a b] = max(K); X2(k,:) = x2(b);
    y(:,k) = K/a;
end

subaxis(1,2,1, 'Spacing', 0.1, 'MarginBottom', 0.2, 'MarginTop', 0.03, 'MarginLeft', 0.1, 'MarginRight', 0.03)
plot(x2,y,'k',X2,ones(2,1),'*k','linewidth',1);
axis([0 30 0.2 1.1]); grid
xlabel([{'({\itg_m/I_D})_2  (S/A)'}; {'(a)'}]);
ylabel('{\itK} / max({\itK})');
g = text(12,0.75,'{\itV_D_D}=1.2V');
set(g, 'fontsize', 9);
g = text(21,0.95,'{\itV_D_D}=0.9V');
set(g, 'fontsize', 9);

% 2 =============
VDD = 1.2;
for k = 1:length(x1)
    K = (VDD - 2./x1(k) - 2./x2).^2./(1 + x2./x1(k));
    [a b] = max(K);
    y(:,k) = K/a;
    x2max(k,1) = x2(b);
    
end

% plot ======================
h = figure(1);

subaxis(1,2,2)
plot(x2,y,'k',x2max,ones(length(x1),1),'*k','linewidth',1);  
axis([0 30 0.2 1.1]); grid
xlabel([{'({\itg_m/I_D})_2  (S/A)'}; {'(b)'}]);
ylabel('{\itK} / max({\itK})');
g = text(10,0.7,'({\itg_m/I_D})_1=5 S/A');
set(g, 'fontsize', 9);
g = text(21,.98,'25 S/A');
set(g, 'fontsize', 9);

%format_and_save(h, 'Fig4_6', 'W', 5.3, 'H', 3)
