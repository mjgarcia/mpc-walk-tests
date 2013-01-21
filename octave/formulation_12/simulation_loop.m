simdata = init_simdata(mpc, mpc_state);

figure
while (1)
    if (mpc_state.counter == disturb_iter)
        mpc_state.cstate += disturbance;

        hold on
        plot_com_zmp_current(mpc_state);
        hold off
    end


    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);


    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);

    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);
    [Gt, Gt_ub] = form_term_ineq_constraints_05 (robot, mpc, mpc_state, Nfp, S0, U);
    [Gte gte] = form_equality_constraints_05 (mpc, S0, U, Nfp);
    [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, Gt, Gt_ub, Gte, gte);

    tic;
    [X, OBJ, INFO, LAMBDA] = qp ([], H, q, Ge, ge, [], [], [], G, G_ub);
    exec_time = toc();

    if (INFO.info != 0);
        printf("QP with terminal constraints failed\n");
        QP_fail_iter = [QP_fail_iter, mpc_state.counter+1];
%        QP_fail_iter = [QP_fail_iter, disturb_iter];
        [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, [], [], [], []);
        [X, OBJ, INFO, LAMBDA] = qp ([], H, q, [], [], [], [], [], G, G_ub);

        if (INFO.info != 0);
            printf("QP failed\n");
%            keyboard;
            break;
        end
    end


    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, LAMBDA, lambda_mask, exec_time, simdata);


% plot
    hold on
    plot_steps_fixed_current(robot, simdata);
    plot_steps_planned(robot, simdata);
    plot_com_zmp_planned(mpc, simdata);
    plot_cp_planned(simdata);
    hold off
    
%    if (mpc_state.counter == disturb_iter)
%        break;
%    end

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        printf("Not enough data to form preview window\n");
        break;
    end
%    sleep(0.1);
end


%figure
%hold on
%plot_steps_fixed_all(robot, simdata)
%plot_com_zmp_all(simdata)
%title (num2str(disturb_iter))
%plot_cp_all(simdata)
%hold off
