function [Gvs, Gvs_ub] = compute_vs_contraints(mpc, Du, Dv, Cu, Cv, S0p, Up, vs_limits, Nlm, Nfp)

NuN = mpc.N*mpc.Nu;
Gvs = zeros(4*Nlm*mpc.N,NuN+Nfp);
Gvs_ub = zeros(4*Nlm*mpc.N,1);

% For each landmark
for l=1:Nlm
    index1 = 4*(l-1)*mpc.N;
    index2 = index1 + mpc.N;
    index3 = index1 + 2*mpc.N;
    index4 = index1 + 3*mpc.N;
    index5 = index1 + 4*mpc.N;
    
    % Two contraints for u coordinate
    % u_max
    Gvs(index1+1:index2,1:NuN) = Du(:,:,l)*Up;
    % u_min
    Gvs(index2+1:index3,1:NuN) = -Gvs(index1+1:index2,1:NuN);

    DuByS0pPlusCu = Du(:,:,l)*S0p + Cu(l);
    % u_max
    Gvs_ub(index1+1:index2) = vs_limits.u_max*ones(mpc.N,1) - DuByS0pPlusCu;
    % u_min
    Gvs_ub(index2+1:index3) = -vs_limits.u_min*ones(mpc.N,1) + DuByS0pPlusCu;

    % Two contraints for v coordinate
    % v_max
    Gvs(index3+1:index4,1:NuN) = Dv(:,:,l)*Up;
    % v_min
    Gvs(index4+1:index5,1:NuN) = -Gvs(index3+1:index4,1:NuN);

    DvByS0pPlusCv = Dv(:,:,l)*S0p + Cv(l);
    % v_max
    Gvs_ub(index3+1:index4) = vs_limits.v_max*ones(mpc.N,1) - DvByS0pPlusCv;
    % v_min
    Gvs_ub(index4+1:index5) = -vs_limits.v_min*ones(mpc.N,1) + DvByS0pPlusCv;
end