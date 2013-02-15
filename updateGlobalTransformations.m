function [Tw_cm, Tcm_w ,Tw_cam] = updateGlobalTransformations(mpc_state,Tcm_cam,cm_height)

% Center of mass global state
Ocm_w = [mpc_state.cstate(1); mpc_state.cstate(4); cm_height; 0; 0; 0];
Tcm_w = computeTransfMatrix(Ocm_w);
Tw_cm = inv(Tcm_w);

% Update camera transformation
Tw_cam = Tcm_cam*Tw_cm;