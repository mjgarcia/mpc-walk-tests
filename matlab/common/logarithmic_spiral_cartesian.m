function [x y rho theta] = logaritmic_spiral_cartesian(tanPhi,p,q,step)

diff = p-q;
rho0 = norm(diff);
theta0 = atan2(diff(2),diff(1));
if theta0 < 0
    theta0 = theta0 + 2*pi;
end

theta = theta0:step:theta0-pi;
rho = logaritmic_spiral_polar(rho0,theta0,tanPhi, theta);

x = rho.*cos(theta) + q(1);
y = rho.*sin(theta) + q(2);