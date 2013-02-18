function [H, q] = addVisualServoingToObjective(mpc, H, q, Du, Dv, Cu, Cv, lmd_proj, weightsMatrix, S0p, Up, Nlm)

NuN = mpc.N*mpc.Nu;
delta = 0.0012;
%delta = 0.0;

sumH = zeros(NuN, NuN);
sumq = zeros(NuN,1);

for l=1:Nlm
    sumH = sumH + Up'*Du(:,:,l)'*weightsMatrix*Du(:,:,l)*Up + Up'*Dv(:,:,l)'*weightsMatrix*Dv(:,:,l)*Up;

    sumq = sumq + Up'*Du(:,:,l)'*weightsMatrix*(Du(:,:,l)*S0p + (Cu(l) - lmd_proj(1,l))*ones(mpc.N,1)) + ...
                                Up'*Dv(:,:,l)'*weightsMatrix*(Dv(:,:,l)*S0p + (Cv(l) - lmd_proj(2,l))*ones(mpc.N,1));
end

H(1:NuN, 1:NuN) = H(1:NuN, 1:NuN) + delta*sumH;

q(1:NuN) = q(1:NuN) + delta*sumq;