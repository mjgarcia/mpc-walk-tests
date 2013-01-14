function [Gb, Gb_ub] = form_feet_constraint(mpc, mpc_state, constr, Nfp);
    GF = [];
    V = zeros(Nfp);

    for i = 1:Nfp/2;
        GF = blkdiag(GF, constr(1:2));
        V = V + diag(ones(Nfp - (i-1)*mpc.Nz,1),  -(i - 1)*mpc.Nz);
    end

    Gb_ub = constr(3) - GF * repmat(mpc_state.p, Nfp/2, 1);

    GF = GF * V;
    Gb = [zeros(Nfp/2, mpc.N*mpc.Nu),  GF];
end
