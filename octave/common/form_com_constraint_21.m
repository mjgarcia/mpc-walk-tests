function [Gb, Gb_ub] = form_com_constraint_21(mpc, mpc_state, constr, S0p, Up, Nfp);
    GC = [];

    for i = 1:mpc.N;
        GC = blkdiag(GC, constr(1:2));
    end

    Gb_ub = constr(3) - GC * S0p;

    GC = GC * Up;
    Gb = [GC, zeros(mpc.N, Nfp), zeros(mpc.N, 2)];
end
