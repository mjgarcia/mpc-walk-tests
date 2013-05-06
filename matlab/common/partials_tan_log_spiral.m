function [dx dy] = partials_tan_log_spiral(tanPhi,p)

den = (p(:,1) - tanPhi*p(:,2)).^2;
fact = (tanPhi^2 + 1);

dx = -p(:,2).*fact./den;
dy = p(:,1).*fact./den;
