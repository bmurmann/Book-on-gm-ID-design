function y = IDsh(p,VS,VD,VG)
% FUNCTION computes ID/beta of the charge sheet model versus 
% 1) the technology vector p = pMat(T,N,tox) 
% 2) the source voltage VS, drain voltage VD and gate voltage VG, 
%    which may be scalars and equal length column-vectors. 

H = [length(VS) length(VD) length(VG)]; [Y l] = max(H); 
M = Y+1-H;
VS = VS*ones(M(1,1),1); 
VD = VD*ones(M(1,2),1);  
VG = VG*ones(M(1,3),1);  

% COMPUTE
xS = surfpot(p,VS,VG);
xD = surfpot(p,VD,VG);
m = size(p); k = 1; 
while k <= m(1,2),
	psiS = xS(:,k);
	psiD = xD(:,k);
	A = [-.5 -2/3*p(2,k) p(3,k) p(2,k)*p(3,k) 0];
	y(:,k) = p(4,k)*(polyval(A,sqrt(psiD)) - polyval(A,sqrt(psiS)) + VG.*(psiD- psiS));
	k = k + 1;
end 
