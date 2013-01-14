function [G_lb, G, G_ub] = form_constraints (robot, mpc, mpc_state, Nfp, V0c, V, S0z, Uz)
    [Gzmp, Gzmp_lb, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gzr, Gzr_lb, Gzr_ub] = form_zmpref_constraints (robot, mpc, mpc_state, Nfp);

    G = [Gzmp; Gzr];
    G_lb = [Gzmp_lb; Gzr_lb];
    G_ub = [Gzmp_ub; Gzr_ub];
end


%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%


function [Gzr, Gzr_lb, Gzr_ub] = form_zmpref_constraints (robot, mpc, mpc_state, Nfp)
    Ni = mpc_state.counter;

    Gzr_lb = zeros(Nfp,1);
    Gzr_ub = zeros(Nfp,1);

    Rfp = [];

    for i = 1:Nfp/2;
        ind = (i-1)*2 + 1 : i*2;

        Gzr_lb(ind) = mpc_state.pwin(Ni + 1).f_bounds(:,1);
        Gzr_ub(ind) = mpc_state.pwin(Ni + 1).f_bounds(:,2);

        Rfp = blkdiag (Rfp, mpc_state.pwin(Ni + 1).R');

        Ni = Ni + mpc_state.pwin(Ni + 1).support_len;
    end

    Gzr = [zeros(Nfp, mpc.N*mpc.Nu),  Rfp];
end


%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%


function [Gzmp, Gzmp_lb, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz)
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
end
