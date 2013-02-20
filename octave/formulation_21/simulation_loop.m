simdata = init_simdata(mpc, mpc_state);

addpath('../qpOASES');
options = qpOASES_options( 'MPC' );

constr = init_constraint_03();
iter = 1;

if (enabled_steps_plot)
    figure
end
while (1)
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);


% minimize w    
    [H, q] = form_objective_18 (mpc, Nfp);

    [Gzmp, Gzmp_ub] = form_zmp_constraints_18 (robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gfd, Gfd_ub] = form_fd_constraints_18 (robot, mpc, mpc_state, Nfp);
    [Ge ge] = form_equality_constraints_18 (mpc, mpc_state, S0, U, Nfp, []);
    [Gb, Gb_ub] = form_com_constraint_21(mpc, mpc_state, constr, S0p, Up, Nfp);

    [X, OBJ, INFO, LAMBDA, lambda_mask] = qpsolver_wrapper([], H, q, Gzmp, Gzmp_ub, Gfd, Gfd_ub, Gb, Gb_ub, Ge, ge);

    if (INFO.info != 0);
        printf("QP for minimization of w was failed.\n");
        keyboard
    end

    w = X(end-1:end);


% minimize default objective
    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);
    
    [Gzmp, Gzmp_ub] = form_zmp_constraints (robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);
    [Ge, ge] = form_equality_constraints_18 (mpc, mpc_state, S0, U, Nfp, w);
    [Gb, Gb_ub] = form_com_constraint(mpc, mpc_state, constr, S0p, Up, Nfp);

    [X, OBJ, INFO, LAMBDA, lambda_mask] = qpsolver_wrapper([], H, q, Gzmp, Gzmp_ub, Gfd, Gfd_ub, Gb, Gb_ub, Ge, ge);



    if (INFO.info != 0);
        printf("QP with terminal constraints failed\n");
        QP_fail_iter = [QP_fail_iter, iter];
        break;
%        keyboard;
    end


    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, LAMBDA, [], 0, simdata);


% plot
    if (enabled_steps_plot)
%        hold on
%        plot_steps_fixed_current(robot, simdata);
%        plot_steps_planned(robot, simdata);
%        plot_com_zmp_planned(mpc, simdata);
%        plot_cp_planned(simdata);
%        hold off
    end
    

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        printf("Not enough data to form preview window\n");
        break;
    end
    iter = iter + 1;
%    sleep(0.1);
end


if (enabled_steps_plot)
    hold on
    plot_steps_fixed_all(robot, simdata)
    plot_com_zmp_all(simdata)
%    title (num2str(disturb_iter))
%    plot_cp_all(simdata)
    plot_cp_planned(simdata);
    plot_cp_all_planned(simdata);
    plot_steps_planned(robot, simdata);
    plot_com_zmp_planned(mpc, simdata);
    draw_line(constr, 'r', 3);
    hold off
end
