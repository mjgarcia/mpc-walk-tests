clear;
clc;

parameters_robot
parameters_mpc6
parameters_mpc_rot

init_visual_servoing

mpc_state.cstate = [Ocm_w(1); 0; 0; Ocm_w(2); 0; 0];  % Initial CoM state
mpc_state.p = Ocm_w(1:2);                               % Position of the initial support

init_walk_01

simdata = init_simdata(mpc, mpc_state);

mpc_state_rot.cstate = [0; 0; 0; 0; 0; 0];

mpc_state_rot.theta_max_feet_com = deg2rad(10*ones(mpc_rot.N,1));
mpc_state_rot.theta_margin = degtorad(0);
mpc_state_rot.max_vel = 100;

theta_cam = degtorad(0.0);

%deltaInitial = .00005;
%deltaFinal = .005;

deltaInitial = .005;
deltaFinal = .05;

errors = lm_proj - lmd_proj;
normErrorInit = norm(errors);
threshError = 0.2;

figure;

lm_proj_all = [];
obj_all = [];
lm_proj_errors_all = [];
errors_horizon_all = [];
theta_vel_all = [];

it = 0;
%itPert = 40;
itPert = -1;
handlesAxesSteps = zeros(5,1);

while (1)
    it = it + 1;

    % Perturbation of the center of mass
    if it == itPert
    %plot(mpc_state.cstate(1),mpc_state.cstate(4),'+g','MarkerSize',5);
    com_undist = mpc_state.cstate;
    mpc_state.cstate(1) = mpc_state.cstate(1) + 0.01;
    mpc_state.cstate(4) = mpc_state.cstate(4) + 0.07;
    %mpc_state.cstate(6) = mpc_state.cstate(6) - 4;
    %disp('Perturbation');
    %subplot(2,1,2);
    %plot(mpc_state.cstate(1),mpc_state.cstate(4),'+g','MarkerSize',5);
    %hold off;
    %pause;
    end

    % compute the interaction matrix
    if(OPT_L_COURANT)
        L = matIntMire6ddl(lm_proj,Olm_cam(3,:));
    end

    % form matrices
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S, S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);

    [S0_rot, S0p_rot, S0v_rot, S0a_rot, D1, D2] = form_condensing_matrices_rot(mpc_rot, mpc_state_rot, S);

    % Rotation angle optimization
    [H_rot, q_rot] = form_objective_rot (mpc_rot, S0v_rot, Uv, weightsMatrix, D1, D2, L, twistMatrix_cm_cam, errors, Nlm);

    [G_rot, G_rot_ub] = form_rot_constraints (mpc_rot, mpc_state_rot, D1, D2, Up, S0p_rot, Uv, S0v_rot);

    options = optimset('LargeScale','off');
    [X_rot, fval] = quadprog (H_rot, q_rot,G_rot,G_rot_ub,[],[],[],[],[],options);

    cState_rot = S0_rot + U*X_rot;
    mpc_state_rot.cstate = cState_rot(1:6);
    theta_vel_all = [theta_vel_all cState_rot(2)];

    % Form objective and constraints
    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);

    % Update global transformations
    [Tw_cm, Tcm_w, Tw_cam, Tcam_w, Tcm_cam, Tcam_cm, Ocm_w] = updateGlobalTransformations(mpc_state.cstate,cm_height,theta_cam,mpc_state_rot.cstate(1));

    % Position of the landmark in camera frame
    Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
    % Real landmarks projected
    lm_proj = projectToImagePlane(Olm_cam);

    %Add noise
    %sigma = 0.0001;
    sigma = 0.0;
    lm_proj_noisy = lm_proj + sigma*randn(size(lm_proj));
    lm_proj_all = [lm_proj_all; lm_proj];
    lm_proj_errors_all = [lm_proj_errors_all; abs(lm_proj - lmd_proj)];

    % Compute visual servoing matrices
    [Du Dv vs_params] = visual_servoing_matrices(mpc,L,twistMatrix_cm_cam,D1,D2,Nlm);
    %[DuNoisy DvNoisy CuNoisy CvNoisy vs_paramsNoisy] = visual_servoing_matrices(mpc,matProjLinNoisy,Tcm_cam,Tcm_w,Tw_cam,Olm_w,Nlm);

    errors = lm_proj - lmd_proj;
    normError = norm(errors)

    if normError < threshError
        disp('Error is less than threshold');
        %break;
    end

    %delta = -((deltaFinal - deltaInitial)/normErrorInit)*(normError - normErrorInit) + deltaInitial;
    delta = 0.0005/normError^2

    % Add visual servoing parameters to the objective
    [H, q] = addVisualServoingToObjective(mpc, H, q, Du, Dv, errors, weightsMatrix, S0v, Uv, Nlm, delta);

    % Rotaion of the foot steps
    [mpc_state] = update_rotation_zmp(mpc, mpc_state, cState_rot(4:6:end));

    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);

    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);

    % Visual servoing contraints
    %[Gvs, Gvs_ub] = compute_vs_contraints(mpc, Du, Dv, Cu, Cv, S0p, Up, vs_limits, Nlm, Nfp);

    % Combine constraints:
    %   Ge * X = ge
    %   G * X <= G_ub
    [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, [], [], [], []);

    % Add visual constraints
    %[G, G_ub] = add_vs_constraints (G, G_ub, Gvs, Gvs_ub);

    % run solver
    tic;
    %options = optimset('LargeScale','off','Display','off');
    options = optimset('LargeScale','off');
    [X, OBJ, EXITFLAG, OUTPUT, LAMBDA] = quadprog (H, q, G, G_ub, Ge, ge,[],[],[],options);
    exec_time = toc();
    obj_all = [obj_all OBJ];
    if (EXITFLAG ~= 1);
        disp('QP failed');
        %keyboard;
    end

    % Collect data.
    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, LAMBDA, lambda_mask, exec_time, simdata);

    % Simulate position of the landmarks with linear model
    [su sv] = simulate_landmarks(mpc, simdata, vs_params, lm_proj, Nlm);

    errorsHorizon = zeros(2,Nlm);
    for l=1:Nlm
        errorsHorizonU = su(:,l) - repmat(lmd_proj(1,l),mpc.N,1);
        errorsHorizon(1,l) = norm(errorsHorizonU);
        errorsHorizonV = sv(:,l) - repmat(lmd_proj(2,l),mpc.N,1);
        errorsHorizon(2,l) = norm(errorsHorizonV);
    end
    errors_horizon_all = [errors_horizon_all; errorsHorizon/sqrt(mpc.N)];

    % Real position of the landmarks with nonlinear model
    [lm_real_horizon] = real_landmarks(mpc, simdata, Tcm_cam, cm_height, Olm_w, mpc_state_rot.cstate(1));

    %plot_current

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        disp('Not enough data to form preview window');
        break;
    end

    % Without this line Octave does not plot results during simulation.
    %pause(0.01);

end

plot_all