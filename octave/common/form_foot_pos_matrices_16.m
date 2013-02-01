function [Nfp, V0c, V] = form_foot_pos_matrices_16(mpc, mpc_state)
    Nfp = get_fp_num(mpc, mpc_state);

    Ni = mpc_state.counter;

    % generate_fixed_step_vector
    Vc = repmat(eye(2), mpc.N, 1);

    % generate_var_step_matrix
    V = zeros(mpc.N*mpc.Nz, Nfp);
    first = mpc_state.pwin(Ni + 1).support_len * 2;
    Ni = Ni + mpc_state.pwin(Ni + 1).support_len;
    for i = 1:Nfp/2
        ind_x = first + 1 : mpc.N*2;
        ind_y = (i-1)*2 + 1 : i*2;
        V(ind_x, ind_y) = repmat (eye(2), mpc.N - first/2, 1);

        first = first + mpc_state.pwin(Ni + 1).support_len*2;
        Ni = Ni + mpc_state.pwin(Ni + 1).support_len;
    end

    V0c = Vc * mpc_state.p;
end


%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%

function [Nfp] = get_fp_num (mpc, mpc_state)
    Nfp = 0;

    i = mpc_state.pwin(mpc_state.counter + 1).support_len;
    while(i < mpc.N - 1)
        i = i + mpc_state.pwin(mpc_state.counter + i + 1).support_len;
        Nfp = Nfp + mpc.Nz;
    end
end

