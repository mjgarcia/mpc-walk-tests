Nlm = 4;
cm_height = robot.h;
%cm_height = 0.711691;

% Landmark positions
Olm_w = [[5; -0.5; 2*cm_height - 0.5] [5; 0.5; 2*cm_height - 0.5] [5; 0.5; 2*cm_height + 0.5] [5; -0.5; 2*cm_height + 0.5]];

% fig3DSim = figure;
% plot3(Olm_w(1,:),Olm_w(2,:),Olm_w(3,:),'+r');
% 
% % Setup of the scene
% grid on;
% hold on;
% axis([0 6 -3 3 0 3]);

% Center of mass initial position
Ocm_w = [0; 0.0; cm_height; 0; 0; 0.0];
Tcm_w = computeTransfMatrix(Ocm_w);

% Center of mass desired position
Odcm_w = [2.0; -0.5; cm_height; 0; 0; deg2rad(-0)];
Tdcm_w = computeTransfMatrix(Odcm_w);
%drawAxis(Tdcm_w,true);

% Desired camera position with respect of center of mass
%Odcam_cm = [0; 0; 0.26; degtorad([0; 90; -15])];
Ocam_cm = [0; 0; cm_height; 0; deg2rad(90); deg2rad(-90)];
Tcam_cm = computeTransfMatrix(Ocam_cm);
Tcm_cam = inv(Tcam_cm);

Tcam_w = Tcm_w*Tcam_cm;
Tw_cam = inv(Tcam_w);

% Desired camera position
Tdcam_w = Tdcm_w*Tcam_cm;
Tw_dcam = inv(Tdcam_w);
%drawAxis(Tdcam_w,true);

% Projection in the desired position
Olm_dcam = Tw_dcam*[Olm_w;ones(1,Nlm)];
lmd_proj = projectToImagePlane(Olm_dcam);

% Projection in the initial position
Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
lm_proj = projectToImagePlane(Olm_cam);
lm_proj_init = lm_proj;
%axis([-0.4 0.0 -0.2 0.2 ])

skewTranslation_cm_cam = [0 -Tcm_cam(3,4) Tcm_cam(2,4) ; Tcm_cam(3,4) 0 -Tcm_cam(1,4); -Tcm_cam(2,4) Tcm_cam(1,4) 0];
twistMatrix_cm_cam = [Tcm_cam(1:3,1:3) skewTranslation_cm_cam*Tcm_cam(1:3,1:3); zeros(3) Tcm_cam(1:3,1:3)];

colors = get(0,'DefaultAxesColorOrder');

weightsMatrix = diag(2.^(0:mpc.N-1));
%weightsMatrix = eye(mpc.N);

L = matIntMire6ddl(lmd_proj,Olm_dcam(3,:));

vs_limits.u_min = -inf;
vs_limits.u_max = inf;
vs_limits.v_min = -inf;
vs_limits.v_max = inf;

OPT_L_COURANT  = true;