function [H, q] = form_objective_03 (robot, mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp, tau)
    load_constants


    H = zeros (mpc.Nu * mpc.N  +  Nfp);
    q = zeros (mpc.Nu * mpc.N  +  Nfp, 1);

    NuN = mpc.N*mpc.Nu;

    H(1:NuN, 1:NuN) = mpc.mu * Uv'* Uv   +   mpc.gamma * Uz' * Uz  + mpc.beta * eye(NuN);

    H(NuN+1:end, NuN+1:end)  = mpc.alpha/tau^2 * eye(Nfp)  +  mpc.gamma * V' * V;

    H(1:NuN, NuN+1:end) =  -mpc.gamma * Uz' * V;
    H(NuN+1:end, 1:NuN) =  H(1:NuN, NuN+1:end)';


    W = repmat([0; robot.feet_dist_default], Nfp/2, 1);

    Ni = mpc_state.counter;
    W = [];
    Rfp = [];
    cVel_ref = [];
    for i = 1:Nfp/2;
        Rfp = blkdiag (Rfp, mpc_state.pwin(Ni + 1).R');
        cVel_ref = [cVel_ref; mpc_state.pwin(Ni + 1).cvel_ref];

        w = [0; robot.feet_dist_default];
        if (mpc_state.pwin(Ni + 1).support_type == LSS)
            w = -w;
        elseif (mpc_state.pwin(Ni + 1).support_type == DS)
            next = Ni + mpc_state.pwin(Ni + 1).support_len;
            if (mpc_state.pwin(next + 1).support_type == RSS)
                w = -w/2;
            else
                w = w/2;
            end
        end
        W = [W; w];

        Ni = Ni + mpc_state.pwin(Ni + 1).support_len;
    end

    q(1:NuN) = mpc.gamma * S0z' * Uz  -  mpc.gamma * V0c' * Uz  +  mpc.mu * S0v' * Uv;

    if (Nfp > 0)
        q(NuN+1:end) = -mpc.alpha * (1/tau^2 * W' * Rfp + 1/tau * cVel_ref') + mpc.gamma * V0c' * V  -  mpc.gamma * S0z' * V;
    else
        q(NuN+1:end) = mpc.gamma * V0c' * V  -  mpc.gamma * S0z' * V;
    end
end

