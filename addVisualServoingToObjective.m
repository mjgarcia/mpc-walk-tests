function [H, q] = addVisualServoingToObjective(mpc, H, q, Du, Dv, Cu, Cv, lmd_proj, weightsMatrix, S0p, Up)

NuN = mpc.N*mpc.Nu;

s = size(lmd_proj);
s = s(2);

delta = 0.0001;
H(1:NuN, 1:NuN) = H(1:NuN, 1:NuN) + delta*(s*Up'*Du'*weightsMatrix*Du*Up + s*Up'*Dv'*weightsMatrix*Dv*Up);

diff_u = lmd_proj(1,:)' - Cu;
diff_v = lmd_proj(2,:)' - Cv;

q(1:NuN) = q(1:NuN) + delta*(Up'*Du'*weightsMatrix*(s*Du*S0p + sum(diff_u)*ones(mpc.N,1)) + ...
                            Up'*Dv'*weightsMatrix*(s*Dv*S0p + sum(diff_v)*ones(mpc.N,1)) );