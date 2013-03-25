addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6_18

enabled_steps_plot = true;

QP_fail_iter = [];
max_state_val = [];
disturbance = [0.0; 
               0.0;
               0.0;
               0.0;
               -0.0522;
               0.0];
%for disturb_iter = 1:20
    disturb_iter = 10;
    stop_iter = -1;
    flag_first_run = true;

    load ../data/state_form12_counter10.dat;
    mpc_state = mpc_state_copy;
    simdata = simdata_copy;
    mpc_state.pwin(67:82) = [];
    flag_first_run = false;


    simulation_loop
    max_state_val = [max_state_val, max(abs(mpc_state.cstate))];
%end

QP_fail_iter
max_state_val

