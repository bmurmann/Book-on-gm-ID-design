function y = blkm(nch,L,VDS,VGS)
% (ref Blaakmeer)
% VDS (horizontal) and VGS (vertical) 
% y(:,:,1) = gm1
% y(:,:,2) = gd1
% y(:,:,3) = jd1
% y(:,:,4) = gm2
% y(:,:,5) = gd2
% y(:,:,6) = x11

% expl  y = blkm(nch,.5,[.5 .6 .7],.1*(2:6)'); Av0 = y(:,:,1)./y(:,:,2)

% 2D space ===========
	UGS = nch.VGS';      
   	UDS = nch.VDS; 
    [X Y] = meshgrid(UDS,UGS);

    VGS1  = .5*(UGS(1:end-1)+UGS(2:end));
    VDS1  = .5*(UDS(1:end-1)+UDS(2:end));

% derivatives funct of UGS, UDS and L ============= 
  	g_m1 = lookup(nch,'GM_W','VGS',UGS,'VDS',UDS,'L',L);
 	g_d1 = lookup(nch,'GDS_W','VGS',UGS,'VDS',UDS,'L',L);
    GM2 = diff(g_m1)./diff(Y);
      g_m2 = interp1(VGS1,GM2,UGS,'pchip');
    GD2 = (diff(g_d1')./diff(X'));
      g_d2 = interp1(VDS1,GD2,UDS,'pchip')';
    X11 = diff(g_d1)./diff(Y);
      x_11 = interp1(VGS1,X11,UGS,'pchip');
      
% change UGS,UDS into VGS,VDS ===============
% since 'pchip' is invalid with interp2, keep 'spline'

    % first order ===============
y(:,:,1) = interp2(X,Y,g_m1,VDS,VGS,'spline');              % gm1  
y(:,:,2) = interp2(X,Y,g_d1,VDS,VGS,'spline');              % gd1 
y(:,:,3) = lookup(nch,'ID_W','VGS',VGS,'VDS',VDS,'L',L);    % jd1
    % second order ==============
y(:,:,4) = interp2(X,Y,g_m2,VDS,VGS,'spline');           	% gm2
y(:,:,5) = interp2(X,Y,g_d2,VDS,VGS,'spline');            	% gd2
y(:,:,6) = interp2(X,Y,x_11,VDS,VGS,'spline');             	% x11

