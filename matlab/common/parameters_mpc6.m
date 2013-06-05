%%
% MPC
clear mpc;
mpc.N = 16;         % length of the preview window (iterations)
mpc.T = 0.1;        % duration of one iteration (second)
% 
% gains
mpc.alpha = 10.0;      % Velocity tracking
mpc.beta = 0.0001; % Jerk penalty
mpc.gamma = 1000; % ZMP centering
%%

mpc.alpha_h = 10.0;      % Velocity tracking
mpc.beta_h = 0.0001; % Jerk penalty
mpc.gamma_h = 200; % ZMP centering

% % gains
% mpc.alpha = 0;      % Velocity tracking
% mpc.beta = 0.1; % Jerk penalty
% mpc.gamma = 0.01; % ZMP centering
% %%

%%% Do not change the following matrices.
mpc.Ns = 6;     % Number of state variables
mpc.Nu = 2;     % Number of control variables
mpc.Nz = 2;     % 