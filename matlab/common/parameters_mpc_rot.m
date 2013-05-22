%%
% MPC
clear mpc_rot;
mpc_rot.N = 16;         % length of the preview window (iterations)
mpc_rot.T = 0.1;        % duration of one iteration (second)
% 
% gains
mpc_rot.alpha = 1;      % Angle tracking
mpc_rot.beta = 10; % Jerk penalty
mpc_rot.gamma = 1; % Feet and CoM angles difference
%%

%%% Do not change the following matrices.
mpc_rot.Ns = 6;     % Number of state variables
mpc_rot.Nu = 2;     % Number of control variables