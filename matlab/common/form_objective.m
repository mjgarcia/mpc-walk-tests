function [H, q] = form_objective (mpc, S0p, Up, S0v, Uv, S0z, Uz, V0c, V, AB0xy, Vel0, Nfp, backward_holonomic_forward)
    H = zeros (mpc.Nu * mpc.N  +  Nfp);
    q = zeros (mpc.Nu * mpc.N  +  Nfp, 1);

    NuN = mpc.N*mpc.Nu;

    % Velocity terms from planning
    if backward_holonomic_forward ~= 0
        alpha = mpc.alpha;
        beta = mpc.beta;
        gamma = mpc.gamma;

        tmp1 = Up'*AB0xy*Uv;
        tmp2 = AB0xy*Up;
        Hvel = alpha * ((Uv'*Uv) + tmp1 + tmp1'+ (tmp2'*tmp2));
        qvel = alpha * (Up'*AB0xy'*(AB0xy*S0p + Vel0 + S0v) + Uv'*(AB0xy*S0p + Vel0 + S0v))';
    else
        alpha = mpc.alpha_h;
        beta = mpc.beta_h;
        gamma = mpc.gamma_h;

        Hvel = alpha * (Uv'*Uv);
        qvel = alpha * (S0v - Vel0)' * Uv;
    end

    % Terms of the jerk and zmp centering
    H(1:NuN, 1:NuN) = Hvel +  beta * eye(NuN)  +  gamma * (Uz' * Uz);

    H(NuN+1:end, NuN+1:end)  =  gamma * (V' * V);

    H(1:NuN, NuN+1:end) =  -gamma * Uz' * V;
    H(NuN+1:end, 1:NuN) =  H(1:NuN, NuN+1:end)';

    q(1:NuN) =  qvel +  gamma * (S0z - V0c)' * Uz;

    q(NuN+1:end) = gamma * (V0c - S0z)' * V;
end

