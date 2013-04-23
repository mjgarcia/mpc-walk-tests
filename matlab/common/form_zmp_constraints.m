function [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz)
    load_constants

    Gzmp_lb = [];
    Gzmp_ub = [];
    Ni = mpc_state.counter;

    Rzmp = [];

    for i = 1:mpc.N;
        Rzmp = blkdiag(Rzmp, mpc_state.pwin(Ni + i).R');

        if (mpc_state.pwin(Ni + i).support_type == DS)
            Gzmp_lb = [Gzmp_lb; robot.ds_zmp_bounds(:,1)];
            Gzmp_ub = [Gzmp_ub; robot.ds_zmp_bounds(:,2)];
        else
            Gzmp_lb = [Gzmp_lb; robot.ss_zmp_bounds(:,1)];
            Gzmp_ub = [Gzmp_ub; robot.ss_zmp_bounds(:,2)];
        end
    end

    const_part = Rzmp * (S0z - V0c);
    Gzmp_lb = Gzmp_lb - const_part;
    Gzmp_ub = Gzmp_ub - const_part;

    Gzmp = [Rzmp*Uz, -Rzmp*V];


    Gzmp = [Gzmp; -Gzmp];
    Gzmp_ub = [Gzmp_ub; -Gzmp_lb];
end
