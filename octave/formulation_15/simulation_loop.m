[simdata] = init_simdata(mpc, mpc_state);

constr = init_constraint_01();

figure
while (1)
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);


    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);

    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);
    [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, [], [], [], []);
    [Gb, Gb_ub] = form_feet_constraint_14(robot, mpc, mpc_state, constr, Nfp);

    tic;
    [X, OBJ, INFO, LAMBDA] = qp ([], H, q, Ge, ge, [], [], [], [G; Gb], [G_ub; Gb_ub]);
    exec_time = toc();

    if (INFO.info != 0);
        printf("QP failed\n");
        keyboard
    end


    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, LAMBDA, lambda_mask, exec_time, simdata);


% plot
    hold on
    plot_fixed_current(robot, simdata);
    plot_planned_current(robot, simdata);
    plot_com_zmp_current(mpc, simdata);
%    plot_cp_current(simdata);
    draw_line(constr, 'r', 3);
    hold off


%next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        printf("Not enough data to form preview window\n");
        break;
    end
    sleep(0.1);
end

%hold on
%plot_fixed_all(robot, simdata)
%plot_com_zmp_all(simdata)
%draw_line(constr, 'r', 3);
%hold off

