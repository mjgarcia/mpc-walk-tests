simdata = init_simdata(mpc, mpc_state);

QP_stab_fail_iter = [];
iter = 1;

cla
while (1)
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, S0v, S0z, U, Uv, Uz] = form_condensing_matrices(mpc, mpc_state);


    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);
    [G_lb, G, G_ub] = form_constraints (robot, mpc, mpc_state, Nfp, V0c, V, S0z, Uz);
    [Gt_lb, Gt, Gt_ub] = form_term_ineq_constraints_05 (robot, mpc, mpc_state, Nfp, S0, U);
    [Ge ge] = form_equality_constraints_05 (mpc, S0, U, Nfp);
    tic;
    [X, OBJ, INFO, LAMBDA] = qp ([], H, q, Ge, ge, [], [], [G_lb; Gt_lb], [G; Gt], [G_ub; Gt_ub]);
    exec_time = toc();

    if (INFO.info != 0);
        printf("QP with terminal constraints failed\n");
        QP_stab_fail_iter = [QP_stab_fail_iter iter];
%        [X, OBJ, INFO, LAMBDA] = qp ([], H, q, [], [], [], [], G_lb, G, G_ub);
%
%        if (INFO.info != 0);
%            printf("QP failed\n");
            keyboard;
%        end
    end


    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, exec_time, simdata);


% plot
    hold on
    plot_fixed_current(robot, simdata);
    plot_planned_current(robot, simdata);
    plot_com_zmp_current(mpc, simdata);
    plot_cp_current(simdata);
    hold off
    

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        printf("Not enough data to form preview window\n");
        break;
    end
    iter = iter + 1;
    sleep(0.1);
end

%QP_stab_fail_iter
