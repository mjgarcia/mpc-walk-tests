%%
% walk
clear walk;
load_constants

walk.ss_len = 8; % duration of one SS (iterations)
walk.theta_inc = 0.2;
walk.velocity = [0.2; 0.0];

walk.steps(1).type = DS;
walk.steps(1).len = 2;
walk.steps(1).theta = 0.0;
walk.steps(1).cvel_ref = walk.velocity;

walk.steps(2).type = RSS;
walk.steps(2).len = walk.ss_len;
walk.steps(2).theta = 0.0;
walk.steps(2).cvel_ref = walk.velocity; 

for i = 3:8
    if walk.steps(i-1).type == RSS
        walk.steps(i).type = LSS;
    else
        walk.steps(i).type = RSS;
    end
    walk.steps(i).len = walk.ss_len;
    walk.steps(i).theta = walk.steps(i-1).theta + walk.theta_inc;
    walk.steps(i).cvel_ref = walk.velocity;
end

walk.steps(end+1).type = DS;
walk.steps(end).len = mpc.N;
walk.steps(end).theta = walk.steps(end-1).theta;
walk.steps(end).cvel_ref = [0; 0];
%%

clear mpc_state;

%%
% state
mpc_state.counter = 0; % Number of iterations
mpc_state.cstate = [0; 0; 0; 0; 0; 0]; % CoM state
mpc_state.p = [0; 0];
mpc_state.stop = 0;
%%

mpc_state = form_preview_data(robot, mpc_state, mpc, walk);
