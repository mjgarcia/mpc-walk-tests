function [Tw_cm, Tcm_w ,Tw_cam, Tcam_w, Tcm_cam, Tcam_cm] = updateGlobalTransformations(state,cm_height,theta_cam,theta_com)

% Center of mass global state
Ocm_w = [state(1); state(4); cm_height; 0; 0; theta_com];
Tcm_w = computeTransfMatrix(Ocm_w);
Tw_cm = inv(Tcm_w);

% Camera position with respect of center of mass
Ocam_cm = [0; 0; 0.26; 0; degtorad(90); theta_cam];
Tcam_cm = computeTransfMatrix(Ocam_cm);
Tcm_cam = inv(Tcam_cm);

% Update camera transformation
Tcam_w = Tcm_w*Tcam_cm;
Tw_cam = Tcm_cam*Tw_cm;