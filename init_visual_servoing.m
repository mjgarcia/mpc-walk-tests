% Landmark positions
Olm_w = [[5; -0.1; 0.5] [5; 0.1; 0.5] [5; 0.1; 0.7] [5; -0.1; 0.7]];
%Olm_w = [5; -0.1; 1.5];
Nlm = 4;
cm_height = 0.26;

% fig3DSim = figure;
% plot3(Olm_w(1,:),Olm_w(2,:),Olm_w(3,:),'+r');
% 
% % Setup of the scene
% grid on;
% hold on;
% axis([0 6 -3 3 0 3]);

% Center of mass initial position
Ocm_w = [0; 0.0; cm_height; 0; 0; degtorad(0)];
Tcm_w = computeTransfMatrix(Ocm_w);

% Center of mass desired position
Odcm_w = [0.5; 0.5; cm_height; 0; 0; degtorad(0)];
%Odcm_w = [1; 0.5; cm_height; 0; 0; 0];
Tdcm_w = computeTransfMatrix(Odcm_w);
%drawAxis(Tdcm_w,true);

% Desired camera position with respect of center of mass
%Odcam_cm = [0; 0; 0.26; degtorad([0; 90; -15])];
Odcam_cm = [0; 0; 0.26; 0; degtorad(90); 0];
Tdcam_cm = computeTransfMatrix(Odcam_cm);
Tcm_dcam = inv(Tdcam_cm);

Tcam_w = Tcm_w*Tdcam_cm;
Tw_cam = inv(Tcam_w);

% Desired camera position
Tdcam_w = Tdcm_w*Tdcam_cm;
Tw_dcam = inv(Tdcam_w);
%drawAxis(Tdcam_w,true);

% Projection in the desired position
Olm_dcam = Tw_dcam*[Olm_w;ones(1,Nlm)];
lmd_proj = projectToImagePlane(Olm_dcam);

% Projection in the initial position
Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
lm_proj = projectToImagePlane(Olm_cam);

fig2DProj = figure;
plot([lm_proj(1,:) lm_proj(1,1)],[lm_proj(2,:) lm_proj(2,1)],'-r','LineWidth',1);
hold on;
plot([lmd_proj(1,:) lmd_proj(1,1)],[lmd_proj(2,:) lmd_proj(2,1)],'-c','LineWidth',1);
%axis([-0.4 0.0 -0.2 0.2 ])

colors = get(0,'DefaultAxesColorOrder');

weightsMatrix = diag(2.^(0:mpc.N-1));
%weightsMatrix = eye(mpc.N);

% Angle controller
pid_theta_com.state = degtorad(0.0);
pid_theta_com.gain_prop = 0.015;
pid_theta_com.gain_int = 0.0;
pid_theta_com.gain_deriv = 0.0;
pid_theta_com.error = 0.0;
pid_theta_com.cum_error = 0.0;
pid_theta_com.diff_error = 0.0;
pid_theta_com.prev_error = pid_theta_com.error;
pid_theta_com.reference = Odcm_w(6);

vs_limits.u_min = -inf;
vs_limits.u_max = inf;
vs_limits.v_min = -inf;
vs_limits.v_max = inf;