simdata = init_simdata(mpc, mpc_state);

cla
while (1)
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, S0v, S0z, U, Uv, Uz] = form_condensing_matrices(mpc, mpc_state);


    tau = mpc.T * walk.ss_len;
    [H, q] = form_objective_03 (robot, mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp, tau);
    [G_lb, G, G_ub] = form_constraints (robot, mpc, mpc_state, Nfp, V0c, V, S0z, Uz);
    tic;
    [X, OBJ, INFO, LAMBDA] = qp ([], H, q, [], [], [], [], G_lb, G, G_ub);
    exec_time = toc();

    if (INFO.info != 0);
        printf("QP failed\n");
        keyboard;
    end


    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, exec_time, simdata);


% plot
    hold on
    plot_fixed_current(robot, simdata);
    plot_planned_current(robot, simdata);
    plot_com_zmp_current(mpc, simdata);
    hold off


% next    
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        printf("Not enough data to form preview window\n");
        break;
    end

    sleep(0.1);
end
