function [H, q] = addVisualServoingToObjective(mpc, H, q, Du, Dv, errors, weightsMatrix, S0v, Uv, Nlm, delta)

NuN = mpc.N*mpc.Nu;

sumH = zeros(NuN, NuN);
sumq = zeros(NuN,1);

fact = 0.01;

for l=1:Nlm
    sumH = sumH + delta*(fact*Uv'*Du(:,:,l)'*weightsMatrix*Du(:,:,l)*Uv + Uv'*Dv(:,:,l)'*weightsMatrix*Dv(:,:,l)*Uv);

    sumq = sumq + delta*(fact*Uv'*Du(:,:,l)'*weightsMatrix*(Du(:,:,l)*S0v + errors(1,l)*ones(mpc.N,1)) + ...
                                Uv'*Dv(:,:,l)'*weightsMatrix*(Dv(:,:,l)*S0v + errors(2,l)*ones(mpc.N,1)));
end

H(1:NuN, 1:NuN) = H(1:NuN, 1:NuN) + sumH;

q(1:NuN) = q(1:NuN) + sumq;