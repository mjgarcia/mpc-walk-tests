function [Ge ge] = form_equality_constraints_05 (mpc, S0, U, Nfp)
    Ia = eye(6)([3, 6], :);

    ind = (mpc.N-1)*mpc.Ns + 1 : mpc.N*mpc.Ns;
    Ge = [Ia * U(ind, :),  zeros(2, Nfp)];
    ge = -Ia * S0(ind, :);
end
