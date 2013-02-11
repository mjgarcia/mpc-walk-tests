%%
% MPC
clear mpc;
mpc.N = 16;         % length of the preview window (iterations)
mpc.T = 0.1;        % duration of one iteration (second)

% gains
mpc.alpha = 1;      % Velocity tracking
mpc.beta = 0.00001; % Jerk penalty
mpc.gamma = 0.0001; % ZMP centering
%%


%%% Do not change the following matrices.
mpc.Ns = 6;     % Number of state variables
mpc.Nu = 2;     % Number of control variables
mpc.Nz = 2;     % 


function out = A(T)
    out = [ 1   T   T^2/2   0   0   0;
            0   1   T       0   0   0;
            0   0   1       0   0   0;
            0   0   0       1   T   T^2/2;
            0   0   0       0   1   T;
            0   0   0       0   0   1];
end % EOF A


function out = B(T)
    out = [ T^3/6   0;
            T^2/2   0;
            T       0;
            0       T^3/6;
            0       T^2/2;
            0       T];
end % EOF B

