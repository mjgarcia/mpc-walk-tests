function [lm_real_horizon] = real_landmarks(mpc, simdata,Tcm_cam,cm_height, Olm_w)
s = size(Olm_w);

lm_real_horizon = zeros(2,s(2),mpc.N);

for k = 1:mpc.N
    % Center of mass global state
    Ocm_w = [simdata.cstateProfile(mpc.Ns*(k-1)+1, end); simdata.cstateProfile(mpc.Ns*(k-1)+4, end); cm_height; 0; 0; 0];
    Tcm_w = computeTransfMatrix(Ocm_w);
    Tw_cm = inv(Tcm_w);

    % Update camera transformation
    Tw_cam = Tcm_cam*Tw_cm;
    
    Olm_cam = Tw_cam*[Olm_w;ones(1,s(2))];
    
    lm_proj = projectToImagePlane(Olm_cam);
    
    lm_real_horizon(:,:,k) = lm_proj;
end