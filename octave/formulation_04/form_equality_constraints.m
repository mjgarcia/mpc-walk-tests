function [Ge ge] = form_equality_constraints(mpc, S0, U, Nfp)
    Iva = eye(6)([2, 3, 5, 6], :);

    ind = (mpc.N-1)*mpc.Ns + 1 : mpc.N*mpc.Ns;
    Ge = [Iva * U(ind, :),  zeros(4, Nfp)];
    ge = -Iva * S0(ind, :);
end
