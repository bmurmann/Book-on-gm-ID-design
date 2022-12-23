function y = pMat(T,N,tox)
% name : technology vector
% computes y = [phiB; Gamma; UT; K; Cox]
% versus
% 	T absolute temperature				°K   
%	N substrate (uniform) doping		cm^-3
%		N > 0  for P-type substrate
%		N < 0  for N-type substrate
% 	tox  oxide thickness   				nm
% NOTE: T, N and tox may be scalars or equal length row vectors 


% physical constants.
T0 = 300;          	% ref temperature..................... K
UG = 1.205;        	% band gap voltage ................... V
q = 1.602e-19;     	% electron charge .................... C
UT0 = .0259;       	% thermal voltage (300°K) ............ V
ni0 = 1.45e10;     	% intrinsic concentration (300°K)..... cm^-3
epsSi = 1.04e-12;  	% oxide dielectr. permit. ............ F/cm
epsOx = .345e-12;  	% silicon dielectr. permit. .......... F/cm
muno = 500;			% N-type mobility (N = ???) .......... cm^2/V.s
mupo = 190;			% P-type mobility (N = ???) .......... cm^2/V.s
					
	
% change T, N and tox equal sizes column vectors.
H = [length(T) length(N) length(tox)]; 
[Y l] = max(H); M = Y+1-H;
Z = [T*ones(1,M(1,1)); N*ones(1,M(1,2)); tox*ones(1,M(1,3))];

% compute technology matrix
z = sign(N(1,1)); mu = ((z+1)*muno - (z-1)*mupo)/2;
k = 1; 
while k <= Y,
		  T = Z(1,k); N = abs(Z(2,k)); tox = Z(3,k);
        % intrinsic conc. ......... .................. cm^(-3)
          ni = ni0*exp((UG/(2*UT0))*(1 - T0/T))*((T/T0).^1.5);
        % thermal voltage ............................ V
          UT = UT0*(T/T0);
        % bulk potential ............................. V
          phiB = z*UT*log(N/ni);
        % oxide cap per unit area  ................... F/cm^2
          Cox = epsOx/(tox*1e-7); 
        % gamma (body effect coefficient)............. sqrt(V)   
          Gamma = sqrt(2*q*epsSi*N)/Cox;
		% µoC'ox  .................................... A/V^2
		  K = mu*Cox*(T/T0).^(-2);   
		% matrix construction
		  y(:,k) = [phiB; Gamma; UT; K; Cox]; 
		k = k + 1;
end


