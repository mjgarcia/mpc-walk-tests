function [tan] = tangent_log_spiral(tanPhi,p)

theta = atan2(p(:,2),p(:,1));
% if theta < 0
%     theta = theta + 2*pi;
% end
tan = (sin(theta)/tanPhi + cos(theta))./(cos(theta)/tanPhi - sin(theta));
