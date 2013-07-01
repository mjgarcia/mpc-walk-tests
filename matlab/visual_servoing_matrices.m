function [Du, Dv, Cu Cv, vs_params] = visual_servoing_matrices(mpc, matProjLin,Tcm_cam,Tcm_w,Tw_cam,Olm_w,Nlm)

vs_params.au = zeros(Nlm,1);
vs_params.av = zeros(Nlm,1);
vs_params.bu = zeros(Nlm,1);
vs_params.bv = zeros(Nlm,1);
vs_params.cu = zeros(Nlm,1);
vs_params.cv = zeros(Nlm,1);

NuN = mpc.N*mpc.Nu;
Du = zeros(mpc.N,NuN,Nlm);
Dv = zeros(mpc.N,NuN,Nlm);

for l=1:Nlm
    vs_params.au(l) = -matProjLin(1,1:3,l)*Tw_cam(1:3,1);
    vs_params.av(l) = -matProjLin(2,1:3,l)*Tw_cam(1:3,1);

    vs_params.bu(l) = -matProjLin(1,1:3,l)*Tw_cam(1:3,2);
    vs_params.bv(l) = -matProjLin(2,1:3,l)*Tw_cam(1:3,2);

    tmp = Tw_cam(1:3,1:3)*Olm_w(:,l) + Tcm_cam(1:3,4) - Tw_cam(1:3,3)*Tcm_w(3,4);

    vs_params.cu(l) = matProjLin(1,1:3,l)*tmp + matProjLin(1,4,l);
    vs_params.cv(l) = matProjLin(2,1:3,l)*tmp + matProjLin(2,4,l);

    initial = (l-1)*mpc.N*NuN+1;
    final = l*mpc.N*NuN;

    Du(initial:(NuN+1):final) = vs_params.au(l);
    Du((initial+mpc.N):(NuN+1):final) = vs_params.bu(l);

    Dv(initial:(NuN+1):final) = vs_params.av(l);
    Dv((initial+mpc.N):(NuN+1):final) = vs_params.bv(l);
end

Cu = vs_params.cu;
Cv = vs_params.cv;