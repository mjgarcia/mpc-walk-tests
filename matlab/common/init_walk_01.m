%%
% walk
clear walk;
load_constants

walk.ss_len = 8; % duration of one SS (iterations)
%walk.velocity = [0.07; 0.0]; % reference velocity.
walk.velocity = [0.0; 0.1]; % reference velocity.
%walk.theta_inc = degtorad(-0.16);
%walk.theta_inc = 0.0;

% Support type
walk.steps(1).type = DS;
% Duration (iterations)
walk.steps(1).len = 1;
% Orientation of the support (angle, global)
walk.steps(1).theta = 0;
% Reference velocity for this particular step
walk.steps(1).cvel_ref = walk.velocity;        % velocity vector

%
walk.steps(2).type = RSS;
walk.steps(2).len = walk.ss_len;
walk.steps(2).theta = 0;
walk.steps(2).cvel_ref = walk.velocity;

% Semiautomatic footstep generation.
for i = 3:30
    if walk.steps(i-1).type == RSS
        walk.steps(i).type = LSS;
    else
        walk.steps(i).type = RSS;
    end
    walk.steps(i).len = walk.ss_len;
    %walk.steps(i).theta = walk.steps(i-1).theta + walk.theta_inc;
    walk.steps(i).theta = 0;
    walk.steps(i).cvel_ref = walk.velocity;
end

walk.steps(end+1).type = DS;
walk.steps(end).len = mpc.N;
%walk.steps(end).theta = 0;
walk.steps(end).theta = walk.steps(end-1).theta;
walk.steps(end).cvel_ref = [0; 0];
%%


clear mpc_state;
            
%%      
% state
mpc_state.counter = 0;                  % Number of iterations % Do not change
mpc_state.cstate = [0; 0; 0; 0; 0; 0];  % Initial CoM state
mpc_state.p = [0; 0];                   % Position of the initial support
mpc_state.stop = 0;                     % Stop flag for simulation % Do not change
%%


% Generate data for simulation.
mpc_state = form_preview_data(robot, mpc_state, mpc, walk);

