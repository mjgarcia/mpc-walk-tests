function [Ge ge] = form_equality_constraints_05 (mpc, mpc_state, S0, U, Nfp)
    Ni = mpc_state.counter + mpc.N;
    omega = mpc_state.pwin(Ni).omega;

    Dcpt = [0, 1, 1/omega, 0, 0, 0;
            0, 0, 0      , 0, 1, 1/omega];

    ind = (mpc.N-1)*mpc.Ns + 1 : mpc.N*mpc.Ns;
    Ge = [Dcpt * U(ind, :),  zeros(2, Nfp)];
    
    ge = - Dcpt * S0(ind, :);
end
