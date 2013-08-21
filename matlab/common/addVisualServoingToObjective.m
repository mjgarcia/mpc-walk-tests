function [H, q] = addVisualServoingToObjective(mpc, H, q, Du, Dv, Cu, Cv, lmd_proj, weightsMatrix, S0p, Up, Nlm, delta)

NuN = mpc.N*mpc.Nu;

sumH = zeros(NuN, NuN);
sumq = zeros(NuN,1);

fact = 1;

for l=1:Nlm
    sumH = sumH + delta*(fact*Up'*Du(:,:,l)'*weightsMatrix*Du(:,:,l)*Up + Up'*Dv(:,:,l)'*weightsMatrix*Dv(:,:,l)*Up);

    sumq = sumq + delta*(fact*Up'*Du(:,:,l)'*weightsMatrix*(Du(:,:,l)*S0p + (Cu(l) - lmd_proj(1,l))*ones(mpc.N,1)) + ...
                                Up'*Dv(:,:,l)'*weightsMatrix*(Dv(:,:,l)*S0p + (Cv(l) - lmd_proj(2,l))*ones(mpc.N,1)));
end

H(1:NuN, 1:NuN) = H(1:NuN, 1:NuN) + sumH;

q(1:NuN) = q(1:NuN) + sumq;