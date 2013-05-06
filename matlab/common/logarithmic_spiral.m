clear;
p = [0; 0];
q = [5; 5];

phiDeg = 20;
phiRad = degtorad(phiDeg);
tanPhi = tan(phiRad);
step = -0.001;

[x y rho theta] = logaritmic_spiral_cartesian(tanPhi,p,q,step);

%polar(theta,rho);
figure;
plot(x,y);
hold('on');
axis('equal');

%idx = length(x);
xmq = x - q(1);
ymq = y - q(2);
[tan] = tangent_log_spiral(tanPhi,[xmq' ymq']);

idx = 100;
x1 = x(idx);
y1 = y(idx);
m1 = tan(idx);
x_tan = p(1):0.1:q(1);
y_tan = y1 + m1*(x_tan - x1);

[dtan_dx dtan_dy] = partials_tan_log_spiral(tanPhi,[xmq' ymq']);
idxLin = 300;
tan_approx = tan(idxLin) + dtan_dx(idxLin)*(xmq - xmq(idxLin)) + ...
    dtan_dy(idxLin)*(ymq - ymq(idxLin));

m1_approx = tan_approx(idx);
y_tan_approx = y1 + m1_approx*(x_tan - x1);

plot(x_tan,y_tan,'g');
plot(x_tan,y_tan_approx,'--r');

figure;
plot(x,tan);
hold on;
plot(x,tan_approx,'--g');

% figure;
% plot(dy_dx,x);
% 
% tanPhi = sym('tanPhi');
% rho0 = sym('rho0');
% theta0 = sym('theta0');
% x = sym('x');
% y = sym('y');
% 
% theta = tan(y/x);
% rho = sqrt(x^2+y^2);
% 
% tmp = rho0*exp((theta-theta0)/tanPhi)/tanPhi;
% tanToPath = (tmp*sin(theta) + rho*cos(theta))/(tmp*cos(theta) + rho*sin(theta));
% 
% dx = diff(tanToPath,x);
% 
% (((x^2 + y^2)^(1/2)*(rho0*y*cos(2*tan(y/x)) + rho0*y*tan(y/x)^2*cos(2*tan(y/x))) + (rho0*tanPhi*x^3*cos(2*tan(y/x)))/(x^2 + y^2)^(1/2))/exp((theta0 - tan(1/x*y))/tanPhi) - (rho0^2*y)/exp((2*(theta0 - tan(1/x*y)))/tanPhi) + tanPhi^2*y*(x^2 + y^2) - (rho0^2*y*tan(y/x)^2)/exp((2*(theta0 - tan(1/x*y)))/tanPhi) + tanPhi^2*y*tan(y/x)^2*(x^2 + y^2))/(x^2*((rho0*cos(tan(y/x)))/exp((theta0 - tan(1/x*y))/tanPhi) + tanPhi*sin(tan(y/x))*(x^2 + y^2)^(1/2))^2)
% 

% tanPhi = sym('tanPhi');
% rho0 = sym('rho0');
% theta0 = sym('theta0');
% x = sym('x');
% y = sym('y');
% 
% theta = atan(y/x);
% rho = sqrt(x^2+y^2);
% 
% tanToPath = (sin(theta)/tanPhi + cos(theta))/(cos(theta)/tanPhi - sin(theta));
% 
% dx = diff(tanToPath,x);
% 
% tanPhi = sym('tanPhi');
% rho0 = sym('rho0');
% theta0 = sym('theta0');
% x = sym('x');
% y = sym('y');
% 
% theta = atan(y/x);
% rho = sqrt(x^2+y^2);
% 
% tanToPath = (sin(theta)/tanPhi + cos(theta))/(cos(theta)/tanPhi - sin(theta));
% 
% dx = diff(tanToPath,x);
% dy = diff(tanToPath,y);
% 
% -(y*(tanPhi^2 + 1))/(x - tanPhi*y)^2



