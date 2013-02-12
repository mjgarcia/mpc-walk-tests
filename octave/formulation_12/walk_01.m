addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6

enabled_steps_plot = true;
stop_iter = -1;

QP_fail_iter = [];
max_state_val = [];
disturbance = [0.0; 
               0.5;
               0.0;
               0.0;
               0.0;
               0.0];
for disturb_iter = 1:20
    flag_first_run = true;
    init_walk_01
    simulation_loop
    max_state_val = [max_state_val, max(abs(mpc_state.cstate))];
end

QP_fail_iter
max_state_val

