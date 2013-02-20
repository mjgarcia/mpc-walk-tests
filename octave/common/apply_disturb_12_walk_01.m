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

fail_success = [];

for disturb_counter = 1:10
    disturbance = disturbance + delta_dist;
    [_junk, ind]  = max(abs(disturbance));
    disturbProfile = [disturbProfile, abs(disturbance(ind))];


    if (flag_first_run == true)
        if (disturb_iter == 10)
            load ../data/state_form12_counter10.dat;
            mpc_state = mpc_state_copy;
            simdata = simdata_copy;
            flag_first_run = false;
        %{
        elseif (disturb_iter == 9)
            load ../data/state_form12_counter9.dat;
            mpc_state = mpc_state_copy;
            simdata = simdata_copy;
            flag_first_run = false;
        %}
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


        %omega = mpc_state.pwin(1).omega;
        %Dcpv = [0, 1, 1/omega,   0, 0,       0;
        %        0, 0,       0,   0, 1, 1/omega];
        %
        %cpvProfile = [cpvProfile, norm(Dcpv*mpc_state.cstate)];

        cpvProfile = [cpvProfile, norm(simdata.cpvProfile(end-1:end,end))];
        %comDist = [comDist, norm(simdata.cstateProfile([end-5, end-2],end) - simdata.simstep(end).plannedSteps(end).p)];

        if (norm(simdata.cpvProfile(end-1:end,end)) > 100)
            fail_success = [fail_success, mpc_state.counter];
        else
            fail_success = [fail_success, -1];
        end
    else
        fail_success = [fail_success, mpc_state.counter];
    end
%    plot_cp_velocity(simdata);
end

%QP_fail_iter
%max_state_val

