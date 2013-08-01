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
Ocm_w = [0; 0.0; cm_height; 0; 0; degtorad(0)];
Tcm_w = computeTransfMatrix(Ocm_w);

% Center of mass desired position
Odcm_w = [3.0; 0.0; cm_height; 0; 0; degtorad(0)];
%Odcm_w = [1; 0.5; cm_height; 0; 0; 0];
Tdcm_w = computeTransfMatrix(Odcm_w);
%drawAxis(Tdcm_w,true);

% Camera position with respect of center of mass
%Odcam_cm = [0; 0; 0.26; degtorad([0; 90; -15])];
Ocam_cm = [0; 0; cm_height; 0; degtorad(90); degtorad(-90)];
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
lm_proj_init = projectToImagePlane(Olm_cam);
%axis([-0.4 0.0 -0.2 0.2 ])

weightsMatrix = diag(2.^(0:mpc.N-1));
%weightsMatrix = eye(mpc.N);

% Angle controller
pid_theta_com.state = Ocm_w(6);
pid_theta_com.state_all = pid_theta_com.state;
pid_theta_com.vel = 0.0;
pid_theta_com.vel_all = pid_theta_com.vel;
pid_theta_com.gain_prop = 0.1;
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

%%

maxiter        = 200;               %
% -- Pose init and final of the robot in the world frame
posecMoInit    = [ 0 0 5 0 0 0]; % Object position in the init camera frame
posecMoDes     = [ 0 0 2 0 0 0]; % Object position in the desired camera frame

%posewMo = [5; 0; 2*cm_height; 0; 0; 0];
%wMo = computeTransfMatrix(posewMo);

% -- For Simulation
dt             = .1;              % time delay between two command
cote           = .01;              % size of the target dot
% -- For Visual Servoing
lambda         = 0.3;               % aservissement gain
threshold      = .001 ;             % threshold on the error to stop
BIAIS          = 0 ;
OPT_CORR       = true;
OPT_L_COURANT  = true;

%-------- Matrix Position -------------%
cMo            = computeTransfMatrix(posecMoInit');
cdesMo         = computeTransfMatrix(posecMoDes');

oMcdes         = inv(cdesMo);
% set to 0 the values that are < small
tooSmall       = 1e-10;

% _____ x
% |
% |
% |
% y

%-------- Create the target -----------%
a              = .1;               % related to the target size
Nbpts          = 4;                % nb points 
oP              = [[-0.5; 0.5; 0] [0.5; 0.5; 0] [0.5; -0.5; 0] [-0.5; -0.5; 0]];
cP             = cMo*[oP; ones(1,Nbpts)];

p              = projectToImagePlane(cP);
pinit          = p;               
Z              = cP(3:3:length(cP)); 
cdesP          = cdesMo*[oP; ones(1,Nbpts)]; 
pdes           = projectToImagePlane(cdesP);
Zdes           = cdesP(3:3:length(cP)); 
corre          = 0 ;

%----------------- VISUAL SERVOING LOOP -----------------%
er = 10; % error value init
iter        = 0;
vcam        = zeros(1,6);
vcamReal    = zeros(1,6);
oMc         = inv(cMo); 
oMcfirst    = oMc;
Xc          = [ oMc(1,4)];
Yc          = [ oMc(2,4)];
Zc          = [ oMc(3,4)];
PERIOD      = 16;

%------------------%
% to estimate de/dt
eprec       = zeros(2*length(p),1);
pprec       = zeros(2*length(p),1); 
integrale   = zeros(2*length(p),1);
L           = matIntMire6ddl(pdes,Zdes);
Lcourant    = L;
STOP_CRITERION = false;
VDes        =[];
VReal       =[];
P           =[];
Pcorr       =[];
E           =[];
Ecorr       =[];
NORME       =[];
INTEGRALE   =[integrale];
NORMECORR   =[];
