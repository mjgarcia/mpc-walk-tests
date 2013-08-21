function [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp)
    H = zeros (mpc.Nu * mpc.N  +  Nfp);
    q = zeros (mpc.Nu * mpc.N  +  Nfp, 1);

    fact = .01;
    NuN = mpc.N*mpc.Nu;
    jerkTerm = zeros(NuN,1);
    jerkTerm(1:2:end) = mpc.beta;
    jerkTerm(2:2:end) = fact*mpc.beta;
    jerkTerm = diag(jerkTerm);

    %H(1:NuN, 1:NuN) = mpc.alpha * Uv' * Uv  +  mpc.beta * eye(NuN)  +  mpc.gamma * Uz' * Uz;
    H(1:NuN, 1:NuN) = mpc.alpha * (Uv' * Uv)  +  jerkTerm  +  mpc.gamma * (Uz' * Uz);

    H(NuN+1:end, NuN+1:end)  =  mpc.gamma * V' * V;

    H(1:NuN, NuN+1:end) =  -mpc.gamma * Uz' * V;
    H(NuN+1:end, 1:NuN) =  H(1:NuN, NuN+1:end)';


    cVel_ref = zeros (NuN, 1);
    Ni = mpc_state.counter;
    for i = 1:mpc.N;
        indx = (i-1)*mpc.Nu + 1;
        indy = i*mpc.Nu;
        cVel_ref(indx:indy) = mpc_state.pwin(Ni + i).cvel_ref;
    end


    q(1:NuN) = mpc.alpha * S0v' * Uv  -  mpc.alpha * cVel_ref' * Uv ...
            +  mpc.gamma * S0z' * Uz  -  mpc.gamma * V0c' * Uz;

    q(NuN+1:end) = mpc.gamma * V0c' * V  -  mpc.gamma * S0z' * V;
end

