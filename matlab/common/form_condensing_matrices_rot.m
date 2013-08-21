function [S0_rot, S0p_rot, S0v_rot, S0a_rot, D1, D2, D3] = form_condensing_matrices_rot(mpc_rot, mpc_state_rot, S)

S0_rot = S*mpc_state_rot.cstate;
S0p_rot = S0_rot(1:3:end,:);
S0v_rot = S0_rot(2:3:end,:);
S0a_rot = S0_rot(3:3:end,:);

NuN = mpc_rot.N*mpc_rot.Nu;

D1 = zeros(1,mpc_rot.N*NuN);
D1(1:(2*mpc_rot.N+1):end) = 1;
D1 = reshape(D1,mpc_rot.N,NuN);

D2 = zeros(1,mpc_rot.N*NuN);
D2(mpc_rot.N+1:(2*mpc_rot.N+1):end) = 1;
D2 = reshape(D2,mpc_rot.N,NuN);