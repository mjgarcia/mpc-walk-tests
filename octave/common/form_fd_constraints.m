function [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp)
    Ni = mpc_state.counter;

    Gfd_lb = zeros(Nfp,1);
    Gfd_ub = zeros(Nfp,1);

    Rfp = [];

    for i = 1:Nfp/2;
        ind = (i-1)*2 + 1 : i*2;

        Gfd_lb(ind) = mpc_state.pwin(Ni + 1).f_bounds(:,1);
        Gfd_ub(ind) = mpc_state.pwin(Ni + 1).f_bounds(:,2);

        Rfp = blkdiag (Rfp, mpc_state.pwin(Ni + 1).R');

        Ni = Ni + mpc_state.pwin(Ni + 1).support_len;
    end

    Gfd = [zeros(Nfp, mpc.N*mpc.Nu),  Rfp];

    Gfd = [Gfd; -Gfd];
    Gfd_ub = [Gfd_ub; -Gfd_lb];
end
