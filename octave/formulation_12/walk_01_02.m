addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6


enabled_steps_plot = false;
flag_first_run = true;


[disturbance, delta_dist, disturb_iter] = init_disturbance_02();
if exist('stop_after_iter')
    stop_iter = disturb_iter + stop_after_iter;
else
    stop_iter = disturb_iter;
end


QP_fail_iter = [];
max_state_val = [];
wProfile = [];
comDist = [];
disturbProfile = [];


for disturb_counter = 1:10
    disturbance = disturbance + delta_dist;
    disturbProfile = [disturbProfile, max(disturbance)];


    if (flag_first_run == true)
        init_walk_01
%        load ../data/state_12.dat;
%        flag_first_run = false;
%        mpc_state = mpc_state_copy;
%        simdata = simdata_copy;
    else
        mpc_state = mpc_state_copy;
        simdata = simdata_copy;
    end
    simulation_loop
    max_state_val = [max_state_val, max(abs(mpc_state.cstate))];

    if (INFO.info == 0)
        comDist = [comDist, norm(mpc_state.cstate([1,4]) - mpc_state.p)];

        omega = mpc_state.pwin(1).omega;
        Dcp = [1, 1/omega, 0,   0, 0,       0;
               0, 0,       0,   1, 1/omega, 0];
        D   = [1, 0, -1/omega^2, 0,   0, 0;
               0, 0, 0,         1,   0, -1/omega^2];
        wProfile = [wProfile, norm(simdata.cpProfile(end-1:end,end) - simdata.zmpProfile(end-1:end, end))];

        %comDist = [comDist, norm(simdata.cstateProfile([end-5, end-2],end) - simdata.simstep(end).plannedSteps(end).p)];
        %wProfile = [wProfile, norm(omega*(Dcp-D) * mpc_state.cstate)];
    end
end

%QP_fail_iter
%max_state_val

