% 3.3   Differential amp stages: EKV transfer char + source volt of diff ampl  
clear all
close all
addpath ../../lib

% data ==================
n  = 1.2;                 	% subthreshold slope 
io = 2*logspace(-2,2,5);    % io = I0/IS 
vid = .01*(-20:20);      	% range input diff voltage  (V)

% compute ================
UT = .026;
m  = (.05:.05:1.95); b = find(m==1);
for k = 1:length(io),
    i2  = .5*io(k)*m;
    q2  = .5*(sqrt(1+4*i2)-1); 
    q1  = .5*(-1 + sqrt(1 + 4*(io(k)-q2.^2-q2)));
    vg = n*UT*(2*(q2-q1) + log(q2./q1));
    I(k,:) = 2*interp1(vg,i2,vid,'spline')/io(k) - 1 ; 

    q = q2(b)
    vs = UT*(2*q - (q1+q2) + log(q./sqrt(q1.*q2)));
    DVS(k,:) = interp1(vg,vs,vid,'spline');
end

% plot =================
f1 = figure(1);
subaxis(2,1,1,'Spacing', 0.10, 'MarginBottom', 0.12, 'MarginTop', 0.02, 'MarginLeft', 0.15, 'MarginRight', 0.03); 
plot(vid,I,'k','linewidth',1); axis([-.2 .2 -1 1]); xlabel('(a)'); 
grid
ylabel('{\iti_o_d}/{\itI_0}'); 

subaxis(2,1,2);
plot(vid,DVS,'k','linewidth',1); axis([-.2 .2 -.005 .05]); 
grid
ylabel('{\itv_s}  (V)')
xlabel({'{\itv_i_d}  (V)';'(b)'}); 

%format_and_save(f1, 'Fig3_29', 'W', 4, 'H', 5)  



