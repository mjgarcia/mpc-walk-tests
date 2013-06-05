function [mpc_state mpc_state_rot] = add_localization_noise(mpc_state,mpc_state_rot)
std_pos = 0.0;
sigma_pos = std_pos^2;
noise_pos = normrnd(0,sigma_pos,2,1);

mpc_state.cstate_noisy = mpc_state.cstate;
mpc_state.cstate_noisy(1) = mpc_state.cstate(1) + noise_pos(1);
mpc_state.cstate_noisy(4) = mpc_state.cstate(4) + noise_pos(2);

std_rot = degtorad(0);
sigma_rot = std_rot^2;
mpc_state_rot.noise_rot = normrnd(0,sigma_rot,1,1);

%mpc_state_rot.cstate_noisy(1) = mpc_state_rot.cstate(1) + noise_rot;
%mpc_state_rot.cstate_noisy(4) = mpc_state_rot.cstate(4) + noise_rot;

