function [Du, Dv, vs_params] = visual_servoing_matrices(mpc, L, twistMatrix_cm_cam, D1, D2, Nlm)

vs_params.au = zeros(Nlm,1);
vs_params.av = zeros(Nlm,1);
vs_params.bu = zeros(Nlm,1);
vs_params.bv = zeros(Nlm,1);

NuN = mpc.N*mpc.Nu;
Du = zeros(mpc.N,NuN,Nlm);
Dv = zeros(mpc.N,NuN,Nlm);

tmp1 = tril(ones(mpc.N))*D1;
tmp2 = tril(ones(mpc.N))*D2;

for l=1:Nlm
    idx1 = 2*(l-1)+1;
    idx2 = 2*l;

    vs_params.au(l) = mpc.T*L(idx1,:)*twistMatrix_cm_cam(:,1);
    vs_params.av(l) = mpc.T*L(idx2,:)*twistMatrix_cm_cam(:,1);

    vs_params.bu(l) = mpc.T*L(idx1,:)*twistMatrix_cm_cam(:,2);
    vs_params.bv(l) = mpc.T*L(idx2,:)*twistMatrix_cm_cam(:,2);

    Du(:,:,l) = vs_params.au(l)*tmp1 + vs_params.bu(l)*tmp2;

    Dv(:,:,l) = vs_params.av(l)*tmp1 + vs_params.bv(l)*tmp2;
end