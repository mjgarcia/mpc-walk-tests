% Landmark positions
%Olm_w = [[5; -0.1; 1.5] [5; 0.1; 1.5] [5; 0.1; 1.7] [5; -0.1; 1.7]];
Olm_w = [5; -0.1; 1.5];
Nlm = 1;
cm_height = 0.8;

h3DSim = figure;
plot3(Olm_w(1,:),Olm_w(2,:),Olm_w(3,:),'+r');

% Setup of the scene
grid on;
hold on;
axis([0 6 -3 3 0 6]);

% Center of mass desired position
Odcm_w = [2; -1; cm_height; 0; 0; 0];
Tdcm_w = computeTransfMatrix(Odcm_w);
drawAxis(Tdcm_w);

% Camera position with respect of center of mass
Ocam_cm = [0; 0; 0.8; 0; 90; 0];
Tcam_cm = computeTransfMatrix(Ocam_cm);

% Desired camera position
Tdcam_w = Tdcm_w*Tcam_cm;
Tw_dcam = inv(Tdcam_w);
drawAxis(Tdcam_w);  

% Projection in the desired position
Olm_dcam = Tw_dcam*[Olm_w;ones(1,Nlm)];
lmd_proj = projectToImagePlane(Olm_dcam);

h2DProj = figure;
plot(lmd_proj(2,:),-lmd_proj(1,:),'+b');
hold on;
grid on;
axis([-0.4 0.0 -0.2 0.2 ])

colors = get(0,'DefaultAxesColorOrder');

ITMAX = 40;
% Center of mass initial position
Ocm_w = [1; 0; 0.8; 0; 0; 0];

for it=1:ITMAX
    
    % Update center of mass transformations
    Tcm_w = computeTransfMatrix(Ocm_w);
    figure(h3DSim);
    drawAxis(Tcm_w);

    % Update camera transformations 
    Tcam_w = Tcm_w*Tcam_cm;
    Tw_cam = inv(Tcam_w);
    drawAxis(Tcam_w);

    % Transform to camera frame
    Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
    % Project current features
    lm_proj = projectToImagePlane(Olm_cam);
    
    figure(h2DProj);
    plot(lm_proj(2,:),-lm_proj(1,:),'+g','MarkerSize',4);
      
    if it == 1
        matLinProj = linearizeProjection(Olm_cam);
        coeffsLin = matLinProj(:,1:3)*Tcm_cam(1:3,1:3); 
    end
    
    lm_proj_lin = matLinProj*Olm_cam;
    plot(lm_proj_lin(2,:),-lm_proj_lin(1,:),'+r','MarkerSize',4);
    
    Ocm_w = Ocm_w + [0.01; 0.01; 0; 0; 0; 0];    
    
    pause(0.1);
end
