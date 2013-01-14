function [S0, S0v, S0z, U, Uv, Uz] = form_condensing_matrices(mpc, mpc_state)
    [S, U]  = form_S_U(@A, @B, mpc, mpc_state);

    S0 = S*mpc_state.cstate;

    S0v = S0(2:3:end,:);
    Uv = U(2:3:end,:);

    [Cz] = form_state_to_zmp_matrix (mpc, mpc_state);
    S0z = Cz * S0;
    Uz = Cz * U;
end

%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%

function [Cz] = form_state_to_zmp_matrix (mpc, mpc_state)
    Cz = [];
    Ni = mpc_state.counter;
    for i = 1:mpc.N;
        Czi = [1   0   -mpc_state.pwin(Ni + i).hg     0   0   0;
               0   0   0                    1   0   -mpc_state.pwin(Ni + i).hg];
        Cz = blkdiag (Cz, Czi);
    end
end

