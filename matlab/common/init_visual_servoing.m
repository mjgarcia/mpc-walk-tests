% Landmark positions
Olm_w = [0; 0; 0];
Nlm = 1;

% Center of mass initial position
Ocm_w = [initPos(1); initPos(2); robot.h; 0; 0; initPos(3)];
Tcm_w = computeTransfMatrix(Ocm_w);

% Desired camera position with respect of center of mass
Ocam_cm = [0; 0; robot.h; 0; degtorad(90); degtorad(-90)];
Tcam_cm = computeTransfMatrix(Ocam_cm);
Tcam_w = Tcm_w*Tcam_cm;
Tw_cam = inv(Tcam_w);

% Projection in the initial position
Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
lm_proj_init = projectToImagePlane(Olm_cam);
%axis([-0.4 0.0 -0.2 0.2 ])

phi1 = -1.0;
phi2 = 1.0;

vs_limits.u_min = tan(phi1);
vs_limits.u_max = tan(phi2);
vs_limits.v_min = tan(phi1);
vs_limits.v_max = tan(phi2);