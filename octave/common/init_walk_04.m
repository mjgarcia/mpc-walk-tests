%%
% walk
clear walk;
load_constants

walk.ss_len = 8; % duration of one SS (iterations)
walk.velocity0 = [0.0; 0.0];
walk.velocity1 = [0.1; 0.0];
walk.velocity = walk.velocity0;

walk.steps(1).type = DS;
walk.steps(1).len = 2;
walk.steps(1).theta = 0;
walk.steps(1).cvel_ref = walk.velocity;        % velocity vector

walk.steps(2).type = RSS;
walk.steps(2).len = walk.ss_len;
walk.steps(2).theta = 0;
walk.steps(2).cvel_ref = walk.velocity;

for i = 3:24
    if walk.steps(i-1).type == RSS
        walk.steps(i).type = LSS;
    else
        walk.steps(i).type = RSS;
    end
    walk.steps(i).len = walk.ss_len;
    walk.steps(i).theta = 0;
    walk.steps(i).cvel_ref = walk.velocity;

    if (i == 3)
        walk.velocity = walk.velocity1;
    elseif (i == 8)
        walk.velocity = 2*walk.velocity1;
    elseif (i == 13)
        walk.velocity = 6*walk.velocity1;
    elseif (i == 21)
        walk.velocity = 2*walk.velocity1;
%    elseif (i == 8)
%%        walk.velocity = walk.velocity1([2,1]);
%        walk.velocity = 2*walk.velocity1;
%    elseif (i == 11)
%        walk.velocity = -walk.velocity1;
%        walk.velocity = 3*walk.velocity1;
%    elseif (i == 14)
%        walk.velocity = 4*walk.velocity1;
%        walk.velocity = -walk.velocity1([2,1]);
    end
end

walk.steps(end+1).type = DS;
walk.steps(end).len = mpc.N + 8;
walk.steps(end).theta = 0;
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

