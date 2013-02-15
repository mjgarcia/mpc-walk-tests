function [Du, Dv, Cu Cv, vs_params] = visual_servoing_matrices(mpc, matProjLin,Tcm_cam,Tcm_w,Tw_cam,Olm_w)

vs_params.au = -matProjLin(1,1:3)*Tw_cam(1:3,1);
vs_params.av = -matProjLin(2,1:3)*Tw_cam(1:3,1);

vs_params.bu = -matProjLin(1,1:3)*Tw_cam(1:3,2);
vs_params.bv = -matProjLin(2,1:3)*Tw_cam(1:3,2);

s = size(Olm_w);
vs_params.cu = zeros(s(2),1);
vs_params.cv = zeros(s(2),1);

for l=1:s(2)
    tmp = Tw_cam(1:3,1:3)*Olm_w(:,l) + Tcm_cam(1:3,4) - Tw_cam(1:3,3)*Tcm_w(3,4);

    vs_params.cu(l) = matProjLin(1,1:3)*tmp + matProjLin(1,4);
    vs_params.cv(l) = matProjLin(2,1:3)*tmp + matProjLin(2,4);
end

NuN = mpc.N*mpc.Nu;
Du = zeros(mpc.N,NuN);
Dv = zeros(mpc.N,NuN);

Du(1:(NuN+1):end) = vs_params.au;
Du((mpc.N+1):(NuN+1):end) = vs_params.bu;

Dv(1:(NuN+1):end) = vs_params.av;
Dv((mpc.N+1):(NuN+1):end) = vs_params.bv;

Cu = vs_params.cu;
Cv = vs_params.cv;