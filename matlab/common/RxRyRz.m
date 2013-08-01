function [Rotx, Roty, Rotz] = RxRyRz(v)
% auteur CLaire dune
% Date novembre 2009
% Mouvement de rotation
% voir Diebel06
Rx = v(1) ;
Ry = v(2);
Rz = v(3) ;
Rotx = [1, 0 ,0
     0,cos(Rx),-sin(Rx)
     0,sin(Rx),cos(Rx)];


Roty = [cos(Ry),0,sin(Ry)
     0,1,0
     -sin(Ry),0,cos(Ry)];

Rotz = [cos(Rz),-sin(Rz),0
     sin(Rz),cos(Rz),0
     0,0,1];

%Rotx = [1, 0 ,0
%     0,cos(mtlb_double(Rx)),sin(mtlb_double(Rx))
%     0,-sin(mtlb_double(Rx)),cos(mtlb_double(Rx))];
%
%
%Roty = [cos(mtlb_double(Ry)),0,-sin(mtlb_double(Ry))
%     0,1,0
%     sin(mtlb_double(Ry)),0,cos(mtlb_double(Ry))];
%
%Rotz = [cos(mtlb_double(Rz)),sin(mtlb_double(Rz)),0
%     -sin(mtlb_double(Rz)),cos(mtlb_double(Rz)),0
%     0,0,1];

end