if (flag_first_run)
    simdata = init_simdata(mpc, mpc_state);
end

if (enabled_steps_plot)
    figure
end
while (1)
    if (mpc_state.counter == disturb_iter)
        if (flag_first_run)
            simdata_copy = simdata;
            mpc_state_copy = mpc_state;
            flag_first_run = false;
        end

%        [mpc_state.cstate, mpc_state.cstate+disturbance]

        mpc_state.cstate += disturbance;

        if (enabled_steps_plot)
            hold on
            plot_com_zmp_current(mpc_state);
            hold off
        end
    end


    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);


    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);

    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);
    [Ge ge] = form_equality_constraints_05 (mpc, mpc_state, S0, U, Nfp);

    [X, OBJ, INFO, LAMBDA, lambda_mask] = qpsolver_wrapper([], H, q, Gzmp, Gzmp_ub, Gfd, Gfd_ub, [], [], Ge, ge);

    if (INFO.info != 0);
        printf("QP with terminal constraints failed\n");
        QP_fail_iter = [QP_fail_iter, disturb_iter];
        break;
    end


    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, LAMBDA, lambda_mask, INFO.exec_time, simdata);


% plot
    if (enabled_steps_plot)
%        hold on
%        plot_steps_fixed_current(robot, simdata);
%        plot_steps_planned(robot, simdata);
%        plot_com_zmp_planned(mpc, simdata);
%        plot_cp_planned(simdata);
%        hold off
    end
    
    if (mpc_state.counter == stop_iter)
        break;
    end

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        printf("Not enough data to form preview window\n");
        break;
    end
%    sleep(0.1);
end


if (enabled_steps_plot)
    hold on
    plot_steps_fixed_all(robot, simdata)
    plot_com_zmp_all(simdata)
%    title (num2str(disturb_iter))
%    plot_cp_all(simdata)
    plot_cp_planned(simdata);
%    plot_cp_all_planned(simdata);
    plot_steps_planned(robot, simdata);
    plot_com_zmp_planned(mpc, simdata);
    hold off
end
