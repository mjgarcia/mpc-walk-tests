%%
% walk
clear walk;
load_constants

walk.ss_len = 8; % duration of one SS (iterations)

% % Support type
% walk.steps(1).type = DS;
% % Duration (iterations)
% walk.steps(1).len = 1;
% % Orientation of the support (angle, global)
% walk.steps(1).theta = initPos(3);

% %
% walk.steps(2).type = RSS;
% walk.steps(2).len = walk.ss_len;
% walk.steps(2).theta = initPos(3);
% 
% % Semiautomatic footstep generation.
% for i = 3:100
%     if walk.steps(i-1).type == RSS
%         walk.steps(i).type = LSS;
%     else
%         walk.steps(i).type = RSS;
%     end
%     walk.steps(i).len = walk.ss_len;
%     %walk.steps(i).theta = walk.steps(i-1).theta + walk.theta_inc;
%     walk.steps(i).theta = 0;
% end
% 
% walk.steps(end+1).type = DS;
% walk.steps(end).len = mpc.N;
% %walk.steps(end).theta = 0;
% walk.steps(end).theta = walk.steps(end-1).theta;
% walk.steps(end).cvel_ref = [0; 0];
% % %%
            
%%      
% state
mpc_state.counter = 0;                  % Number of iterations % Do not change
mpc_state.cstate = [initPos(1); 0; 0; initPos(2); 0; 0];  % Initial CoM state
mpc_state.p = initPos(1:2);                               % Position of the initial support
mpc_state.stop = 0;                     % Stop flag for simulation % Do not change
%%

mpc_state_rot.cstate = [initPos(3); 0; 0; initPos(3); 0; 0];
mpc_state_rot.theta_max_feet_com = deg2rad(10*ones(mpc_rot.N,1));
mpc_state_rot.theta_margin = degtorad(0);
mpc_state_rot.max_vel = 100;

% Generate data for simulation.
%mpc_state = form_preview_data(robot, mpc_state, mpc, walk);

