function y = surfpot(p,V,VG)

% Computes the surface potential of MOS transistors knowing 
% 1) the technology vector p = pMat(T,N,tox) 
%    where  T, or N, or tox may be scalars and equal length row columns
% 2) the non-equilibrium voltage V and gate voltage VG which may be
%    scalars and equal length column-vectors.

% voltage matrix
H = [length(V) length(VG)];
[Y I] = max(H); M = Y+1-H;
Z = [ones(M(1,1),1)*V ones(M(1,2),1)*VG]; 

% surface pot.
precision = 1e-8;
m = size(p);
n = 1; while n <= m(1,2),
	phi = p(1,n); Gamma = p(2,n); Gamsq = Gamma^2; UT = p(3,n); 
		k = 1; while k <= Y
 		U = Z(k,1); UG = Z(k,2);
  		psi = (- Gamma/2 + sqrt(Gamsq/4 + UG))^2; 
    		if U < (psi - 2*phi - .05)
      		x = U + .5; ps = psi;
      			while abs((x - ps)/x) > precision
        		ps = x; 
        		A = ((ps - UG)^2 - Gamsq*ps)/(Gamsq*UT);
        		B = 2*(ps - UG)/Gamsq - 1;
        		C = B/A;
        		x = (2*phi + U + UT*log(A) - C*ps)/(1 - C); 
      		end
    	else 
      		x = U + .5; ps = psi; 
     			 while abs((x - ps)/x) > precision
        		ps = x; 
        		A = exp((ps - 2*phi - U)/UT);
        		B = sqrt(ps + UT*A);
        		C = - Gamma*(1 + A)/(2*B);
        		x = (UG - Gamma*B - C*ps)/(1 - C); 
      		end
    	end
  	y(k,n) = real(x);
  	k = k + 1;
	end
n = n + 1;
end
