[simdata] = init_simdata(mpc, mpc_state);

QP_stab_fail_iter = [];
iter = 1;

constr = init_constraint_01();

figure
while (1)
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);


    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);

    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);
    [Gt, Gt_ub] = form_term_ineq_constraints_05 (robot, mpc, mpc_state, Nfp, S0, U);
    [Gte gte] = form_equality_constraints_05 (mpc, S0, U, Nfp);
    [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, Gt, Gt_ub, Gte, gte);
    [Gb, Gb_ub] = form_feet_constraint_14(robot, mpc, mpc_state, constr, Nfp);

    tic;
    [X, OBJ, INFO, LAMBDA] = qp ([], H, q, Ge, ge, [], [], [], [G; Gb], [G_ub; Gb_ub]);
    exec_time = toc();

    if (INFO.info != 0);
        printf("QP with terminal constraints failed\n");
        QP_stab_fail_iter = [QP_stab_fail_iter iter];
        keyboard
    end


    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, LAMBDA, lambda_mask, exec_time, simdata);


% plot
%    cla
%    hold on
%    set(gca(), 'xlim', [-0.1, 0.6])
%    set(gca(), 'ylim', [-0.3, 0.1])
%    plot_steps_fixed_all(robot, simdata);
%    plot_steps_planned(robot, simdata);
%    plot_com_zmp_planned(mpc, simdata);
%    plot_cp_planned(simdata);
%    draw_line(constr, 'r', 3);
%    print_video_frame(mpc_state.counter + 1);
%    hold off
%
    hold on
    plot_steps_fixed_current(robot, simdata);
    plot_steps_planned(robot, simdata);
    plot_com_zmp_planned(mpc, simdata);
%    plot_cp_planned(simdata);
%    plot_com_zmp_current(mpc_state)

    draw_line(constr, 'r', 3);
    hold off
    

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        printf("Not enough data to form preview window\n");
        break;
    end
%    sleep(0.1);
end

%QP_stab_fail_iter

%hold on
%plot_steps_fixed_all(robot, simdata)
%plot_com_zmp_all(simdata)
%draw_line(constr, 'r', 3);
%hold off

