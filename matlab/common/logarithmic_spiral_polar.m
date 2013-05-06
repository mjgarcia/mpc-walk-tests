function [rho] = logaritmic_spiral_polar(rho0,theta0,tanPhi, theta)

rho = rho0.*exp((theta - theta0)/tanPhi);