function [G, G_ub] = form_term_ineq_constraints_05 (robot, mpc, mpc_state, Nfp, S0, U)
    load_constants


    Ni = mpc_state.counter + mpc.N;
    omega = mpc_state.pwin(Ni).omega;

    Iv = eye(6)([2, 5], :);
    Ip = eye(6)([1, 4], :);
    R = mpc_state.pwin(Ni).R';

    ind = (mpc.N-1)*mpc.Ns + 1 : mpc.N*mpc.Ns;
    S0e = S0(ind, :);
    Ue = U(ind, :);


% bounds    
    if (mpc_state.pwin(Ni).support_type == DS)
        G_lb = [robot.ds_zmp_bounds(:,1)];
        G_ub = [robot.ds_zmp_bounds(:,2)];
    else
        G_lb = [robot.ss_zmp_bounds(:,1)];
        G_ub = [robot.ss_zmp_bounds(:,2)];
    end

    const_part = R * Ip * S0e   +  omega * R * Iv * S0e  -  R * mpc_state.p;

    G_lb = G_lb - const_part;
    G_ub = G_ub - const_part;

% matrix

    G = [R * Ip * Ue   +   omega * R * Iv * Ue,   repmat(-R, 1, Nfp/mpc.Nz)];

    G = [G; -G];
    G_ub = [G_ub; -G_lb];
end
