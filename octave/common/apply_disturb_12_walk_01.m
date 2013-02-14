flag_first_run = true;

if exist('stop_after_iter')
    stop_iter = disturb_iter + stop_after_iter;
else
    stop_iter = disturb_iter;
end


QP_fail_iter = [];
max_state_val = [];
cpvProfile = [];
comDist = [];
disturbProfile = [];


for disturb_counter = 1:10
    disturbance = disturbance + delta_dist;
    disturbProfile = [disturbProfile, max(abs(disturbance))];


    if (flag_first_run == true)
        if (disturb_iter == 16)
            load ../data/state_form12_counter16.dat;
            mpc_state = mpc_state_copy;
            simdata = simdata_copy;
            flag_first_run = false;
        elseif (disturb_iter == 9)
            load ../data/state_form12_counter9.dat;
            mpc_state = mpc_state_copy;
            simdata = simdata_copy;
            flag_first_run = false;
        else
            printf('Attention! The walk is initialized starting from the initial DS.\n')
            printf('Different formulations may be at different states, when disturbance is applied.\n');
            init_walk_01;
        end
    else
        mpc_state = mpc_state_copy;
        simdata = simdata_copy;
    end
    simulation_loop
    max_state_val = [max_state_val, max(abs(mpc_state.cstate))];

    if (INFO.info == 0)
        comDist = [comDist, norm(mpc_state.cstate([1,4]) - mpc_state.p)];

        cpvProfile = [cpvProfile, norm(simdata.cpvProfile(end-1:end,end))];
        %comDist = [comDist, norm(simdata.cstateProfile([end-5, end-2],end) - simdata.simstep(end).plannedSteps(end).p)];
    end
%    plot_cp_velocity(simdata);
end

%QP_fail_iter
%max_state_val

