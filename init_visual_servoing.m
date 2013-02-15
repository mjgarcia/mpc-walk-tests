% Landmark positions
Olm_w = [[5; -0.1; 1.5] [5; 0.1; 1.5] [5; 0.1; 1.7] [5; -0.1; 1.7]];
%Olm_w = [5; -0.1; 1.5];
Nlm = 4;
cm_height = 0.8;

fig3DSim = figure;
plot3(Olm_w(1,:),Olm_w(2,:),Olm_w(3,:),'+r');

% Setup of the scene
grid on;
hold on;
axis([0 6 -3 3 0 6]);

% Center of mass desired position
Odcm_w = [1; 1; cm_height; 0; 0; 0];
Tdcm_w = computeTransfMatrix(Odcm_w);
drawAxis(Tdcm_w);

% Camera position with respect of center of mass
Ocam_cm = [0; 0; 0.8; 0; 90; 0];
Tcam_cm = computeTransfMatrix(Ocam_cm);
Tcm_cam = inv(Tcam_cm);

% Desired camera position
Tdcam_w = Tdcm_w*Tcam_cm;
Tw_dcam = inv(Tdcam_w);
drawAxis(Tdcam_w);  

% Projection in the desired position
Olm_dcam = Tw_dcam*[Olm_w;ones(1,Nlm)];
lmd_proj = projectToImagePlane(Olm_dcam);

fig2DProj = figure;
plot(lmd_proj(1,:),lmd_proj(2,:),'+c');
hold on;
grid on;
%axis([-0.4 0.0 -0.2 0.2 ])

colors = get(0,'DefaultAxesColorOrder');

weightsMatrix = diag(2.^(0:mpc.N-1));
%weightsMatrix = eye(mpc.N);