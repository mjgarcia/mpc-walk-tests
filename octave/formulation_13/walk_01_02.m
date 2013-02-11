addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6

enabled_steps_plot = false;
flag_first_run = true;

QP_fail_iter = [];
max_state_val = [];

[disturbance, delta_dist] = init_disturbance_01();
disturb_iter = 6;
stop_iter = disturb_iter + 5;

cpProfile = [];
disturbProfile = [];

for disturb_counter = 1:15
    disturbance = disturbance + delta_dist;
    disturbProfile = [disturbProfile, max(disturbance)];


    if (flag_first_run == true)
%        init_walk_01
        load ../data/state_12.dat;
        flag_first_run = false;
        mpc_state = mpc_state_copy;
        simdata = simdata_copy;
    else
        mpc_state = mpc_state_copy;
        simdata = simdata_copy;
    end
    simulation_loop
    max_state_val = [max_state_val, max(abs(mpc_state.cstate))];

    if (INFO.info == 0)
        cpProfile = [cpProfile, norm(simdata.cpProfile(end-1:end,end) - simdata.zmpProfile(end-1:end, end))];
    end
end

QP_fail_iter
max_state_val

