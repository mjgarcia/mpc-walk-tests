% this code test the asser visu 
% given as an input to Andreis function
% for step computing
% 
%
% test another correction
%;exec('main/testAVrobotErreurMarche.sce');


%function testSwayCorrection(OPT_CORR,OPT_L_COURANT)
addpath('/home/mauricio/Developer/mpc-walk-tests/matlab/common/');

maxiter        = 200;               %
% -- Pose init and final of the robot in the world frame
posecMoInit    = [ 0 0 5 0 0 0]; % Object position in the init camera frame
posecMoDes     = [ 0 0 4 0 0 0]; % Object position in the desired camera frame

cm_height = 0.71;

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
%----------------------------------------------------------------------%
% Servo LOOP
%vcam(6) =0.1;
while( iter < maxiter && STOP_CRITERION==false)

  iter = iter+1;
  disp(['---------------------- ' num2str(iter)]);
  
  e          = p-pdes;                       % compute the error  
  e = reshape(e,2*Nbpts,1);
  
  %-----------------------------------------------------------%/
  % Compute the correction 
  if(OPT_L_COURANT)
    L          = matIntMire6ddl(p,Z);              % compute the interaction matrix
   end 
  eprec      = e;
  corre      = dt*L*(vcamReal-vcam)';
  integrale  = integrale + corre ;
   
  if (OPT_CORR)
    meanint = mean(INTEGRALE,2);
    erreurCourante=e-integrale+meanint;
    normecorr = norm(erreurCourante);
    NORMECORR=[NORMECORR normecorr];
  else
    erreurCourante=e;
  end 
 vcam        = computeVelocity(lambda, L,erreurCourante);
    
   %-----SIMU ROBOT----%
  %deduce vcamReal   
  vcamReal   = vcam;
  vcamReal(1)= vcam(1)+0.4*sin(pi/(PERIOD/2)*(iter-1));
  %vcamReal(2)=0;
  %vcamReal(5)=0;
  %vcamReal(6)=0;
  c1Mc2      = expMapDirectRxRyRz(vcamReal,dt);
  cMo        = inv(c1Mc2)*cMo;
  cMo        = cMo.*(abs(cMo)>1e-10);
 
 
  %----------------------------------------------------%
  % update the position    
  %save the 2D position
  %-----------------------------------------------------%
  % Update variables
  VDes       =[VDes;vcam];
  VReal      =[VReal;vcamReal];
  balancement= vcamReal-vcam;
  cP         = cMo*[oP; ones(1,Nbpts)]; % compute the 3D points
  p          = projectToImagePlane(cP);   % compute the 2D points
  Z          = cP(3:3:length(cP));      % compute Z
 
  tmp = reshape(p,1,2*Nbpts);
  P          = [P; tmp]; %preel
  Pcorr      = [Pcorr; corre']; %pcorrected
  E          = [E; e']; %error
  Ecorr      = [Ecorr; reshape(p-pdes,1,2*Nbpts)]; 
  INTEGRALE  = [INTEGRALE integrale];
  posec      = pFromHomogeneousMatrix(inv(cMo));
  Xc         = [Xc;posec(1)];
  Yc         = [Yc;posec(2)]; 
  Zc         = [Zc;posec(3)];

  NORME      = [NORME;norm(e)];

  if(norm(e)<threshold) 
    STOP_CRITERION=true;
  end 
  
  
  
end;

  
% ---------------------------------------------%
% Display the results 
figure;
hold('on');
title('Point 2D');
for i=1:Nbpts
    plot(Pcorr(:,2*(i-1)+1),Pcorr(:,2*(i-1)+2),'b');
    plot(P(:,2*(i-1)+1),P(:,2*(i-1)+2),'r');
end

% hf_2            = createFigure3D(2,'Camera Motion',2);
% Camera3DDrawColor(0.1,oMcfirst,3);% display the first camera
% Camera3DDrawColor(0.1,oMc,3);% display the first camera
% Camera3DDrawColor(0.1,oMcdes,5);% display the first camera
% Mire3DDraw5pts(oP);
% if (iter>=2)
%   plot3d(Xc,Yc,Zc);
%  end
% Camera3DDraw(0.1,oMc);
% show_pixmap()

figure;
hold('on');
title('Error(plain lines)/correction (doted lines)');
if(iter>2)
  plot(E,'r');
  plot(Ecorr,'g');
end

figure;
hold('on');
title('Velocity');
if(size(VDes,1)>1)
  plot(VDes(:,1),'r-.');
  plot(VDes(:,2),'g-.');
  plot(VDes(:,3),'b-.');
  plot(VReal(:,1),'r');
  plot(VReal(:,2),'g');
  plot(VReal(:,3),'b');
end
legend('x','y','z');

figure;
hold('on');
title('Velocity difference');
if(size(VReal,1)>1)
  plot(VReal(:,1)-VDes(:,1),'r');
  plot(VReal(:,2)-VDes(:,2),'g');
  plot(VReal(:,3)-VDes(:,3),'b');
end

figure;
hold('on');
title('terme correctif');
if(size(INTEGRALE,1)>1)
  plot(INTEGRALE');
end 
  
figure;
hold('on');
title('norme de l erreur');
if(size(NORME,1)>1)
  plot(NORME);
  if (OPT_CORR)
    plot(NORMECORR,'r');
  end
end

