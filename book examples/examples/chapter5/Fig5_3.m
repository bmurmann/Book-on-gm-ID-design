% 5.2   F factor versus rho and W1/W2
clear all
close all
addpath ../../lib

% data ===============
W1_W2 = [2 5 10 20]; z = length(W1_W2);


% compute ===========
q1 = logspace(-4,2,100)';
for k = 1:z
    q = .5*(-1 + sqrt(1 + 4*W1_W2(1,k)*(q1.^2+q1))); 
    F(:,k)  = (2*(q - q1) + log(q./q1))./(1+q);
   	q2(:,k) = q;
end
    % weak inv =========
FWI = log(W1_W2);
    % strong inv ======
FSI = 2*(1 - sqrt(1./W1_W2)); 
    % relative gm/ID
rho = 1./(1+q2);

% plot =================
h = figure(1)
plot(rho,F,'k',zeros(1,z),FSI,'*k',ones(1,z),FWI,'ok','linewidth',1.1);
grid; axis([0 1 0 3])
xlabel('{\it\rho}'); ylabel('{\it F}');
axis([-0.05 1.05 0 3.1]);

text(.6,.8,'{\itW_1}/{\itW_2} = 2', 'fontsize', 9)
text(.7,1.6,'5', 'fontsize', 9)
text(.7,2.2,'10', 'fontsize', 9)
text(.7,2.7,'20', 'fontsize', 9)

%format_and_save(h, 'Fig5_3');

interp1(1./(1+q2(2,:)),F(2,:),.5)

R = 2000;
n = 1.25; UT = 0.026;
gm2 = F/R;
ID = gm2./rho/(n*UT)
R*ID