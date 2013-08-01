function [M] = expMapDirectThetaU(v,dt)
% compute the transformation from the pose t to the pose t+dt
% input : the velocity (m/s,rad/s) and the time to apply it (s) 
% the velocity vector is a ThetaU 

% resulting motion in translation and theta U 
%disp("1.Create the vector v_dt");
v_dt = v * dt;
u = v_dt(4:6);
% compute the rotation matrix 
%disp("2.Compute the rotationmatrix");
rd = rotationMatrixFromThetaU(u);
%rd = rd';
%disp("3.Compute theta");
% compute the translation
theta = sqrt(u(1)*u(1) + u(2)*u(2) + u(3)*u(3));
si = sin(theta);
co = cos(theta);
%disp("4.Compute scinc");
sinca = sinc(theta); 
%mcosc
if(theta<1e-7)
  mcosc=0.5;
else
  mcosc = (1-co)/(theta*theta);
end;
if(theta<1e-8)
  msinc =1/6;
else
  msinc = (1-si)/(theta*theta);
end;
 
td(1) = v_dt(1)*(sinca + u(1)*u(1)*msinc)+ v_dt(2)*(u(1)*u(2)*msinc - u(3)*mcosc)+ v_dt(3)*(u(1)*u(3)*msinc + u(2)*mcosc);
td(2) = v_dt(1)*(u(1)*u(2)*msinc + u(3)*mcosc)+ v_dt(2)*(sinca + u(2)*u(2)*msinc)+ v_dt(3)*(u(2)*u(3)*msinc - u(1)*mcosc);
td(3) = v_dt(1)*(u(1)*u(3)*msinc - u(2)*mcosc)+ v_dt(2)*(u(2)*u(3)*msinc + u(1)*mcosc)+ v_dt(3)*(sinca + u(3)*u(3)*msinc);

troiszeros = zeros(1,3);
M = [rd td';troiszeros 1];
 
%nouvelle version
%w = [v_dt(4); v_dt(5) ; v_dt(6)];
%wsk = skew(w);
%wnorm = norm(w);
% %% Rodrigues 
%rd = eye(3,3) + (sin(wnorm)/wnorm)*wsk + 1/(wnorm^2)*wsk*wsk*(1-cos(wnorm));
%td = ((eye(3,3)-rd)*(wsk*v_dt(1:3)')+w*w'*v_dt(1:3)')/(norm(wsk))
% 
% M2 = [rd td ;troiszeros 1]

end