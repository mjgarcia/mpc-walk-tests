function [Ge ge] = form_equality_constraints_18 (mpc, mpc_state, S0, U, Nfp, w)
    Ni = mpc_state.counter + mpc.N;
    omega = mpc_state.pwin(Ni).omega;

    Dcpt = [0, 1/omega, 1/omega^2, 0, 0, 0;
            0, 0, 0      , 0, 1/omega, 1/omega^2];

    ind = (mpc.N-1)*mpc.Ns + 1 : mpc.N*mpc.Ns;

    if isnull(w)
        Ge = [Dcpt * U(ind, :),  zeros(2, Nfp),  -eye(mpc.Nw)];
        ge = - Dcpt * S0(ind, :);
    else
        Ge = [Dcpt * U(ind, :),  zeros(2, Nfp)];
        ge = - Dcpt * S0(ind, :) + eye(mpc.Nw)*w;
    end
    

%    if !isnull(w)
%        Ge = [Ge;
%              zeros(mpc.Nw, mpc.N*mpc.Nu), zeros(2, Nfp), eye(mpc.Nu)];
%        ge = [ge; w];
%    end
end
