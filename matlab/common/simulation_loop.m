clear;
clc;

parameters_robot
parameters_mpc6

init_walk_01

simdata = init_simdata(mpc, mpc_state);

init_visual_servoing

theta_cam = degtorad(0.0);

delta = .000006;
%delta = .000001;

figure;

lm_proj_all = [];
obj_all = [];
lm_proj_errors_all = [];
errors_horizon_all = [];

it = 0;
itPert = 54;
%itPert = -1;
handlesAxesSteps = zeros(5,1);

while (1)
    it = it + 1;

    % Perturbation of the center of mass
    if it == itPert
    %plot(mpc_state.cstate(1),mpc_state.cstate(4),'+g','MarkerSize',5);
    com_undist = mpc_state.cstate;
    mpc_state.cstate(1) = mpc_state.cstate(1) + 0.02;
    mpc_state.cstate(4) = mpc_state.cstate(4) + 0.04;
    %mpc_state.cstate(6) = mpc_state.cstate(6) - 4;
    disp('Perturbation');
    %plot(mpc_state.cstate(1),mpc_state.cstate(4),'+g','MarkerSize',5);
    %pause;
    end

    pid_theta_com = apply_angle_controller(pid_theta_com,mpc.T);
    radtodeg(pid_theta_com.state)

    % form matrices
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);

    % Form objective and constraints
    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);

    % Update global transformations
    [Tw_cm, Tcm_w, Tw_cam, Tcam_w, Tcm_cam] = updateGlobalTransformations(mpc_state.cstate,cm_height,theta_cam,pid_theta_com.state);
    %figure(fig3DSim);
    %drawAxis(Tcm_w,false);
%     if mod(it,32) == 0
%         drawAxis(Tcam_w,true);
%     else
%         drawAxis(Tcam_w,false);
%     end

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

    % Linearize projection around current landmark positions
    matProjLin = linearizeProjection(Olm_cam,Nlm);
    matProjLinNoisy = linearizeProjectionUsingUV(lm_proj_noisy,Olm_cam(3,:),Nlm);

    % Compute visual servoing matrices
    [Du Dv Cu Cv vs_params] = visual_servoing_matrices(mpc,matProjLin,Tcm_cam,Tcm_w,Tw_cam,Olm_w,Nlm);
    [DuNoisy DvNoisy CuNoisy CvNoisy vs_paramsNoisy] = visual_servoing_matrices(mpc,matProjLinNoisy,Tcm_cam,Tcm_w,Tw_cam,Olm_w,Nlm);

    %lm_proj_lin = matProjLin*Olm_cam;
    %plot(lm_proj_lin(2,:),-lm_proj_lin(1,:),'.r');
    su = zeros(Nlm);
    sv = zeros(Nlm);

    for l=1:Nlm
        su(l) = vs_params.au(l)*Tcm_w(1,4) + vs_params.bu(l)*Tcm_w(2,4) + vs_params.cu(l);
        sv(l) = vs_params.av(l)*Tcm_w(1,4) + vs_params.bv(l)*Tcm_w(2,4) + vs_params.cv(l);
    end
    %plot(su,sv,'.r','MarkerSize',4);

    % Add visual servoing parameters to the objective
    [H, q] = addVisualServoingToObjective(mpc, H, q, Du, Dv, Cu, Cv, lmd_proj, weightsMatrix, S0p, Up, Nlm, delta);

    % Rotaion of the foot steps
    [mpc_state] = update_rotation_zmp(mpc, mpc_state, pid_theta_com.state);

    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);

    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);

    % Visual servoing contraints
    [Gvs, Gvs_ub] = compute_vs_contraints(mpc, Du, Dv, Cu, Cv, S0p, Up, vs_limits, Nlm, Nfp);

    % Combine constraints:
    %   Ge * X = ge
    %   G * X <= G_ub
    [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, [], [], [], []);

    % Add visual constraints
    [G, G_ub] = add_vs_constraints (G, G_ub, Gvs, Gvs_ub);

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
    [su sv] = simulate_landmarks(mpc, simdata, vs_params);
    [suNoisy svNoisy] = simulate_landmarks(mpc, simdata, vs_paramsNoisy);

    errorsHorizon = zeros(2,Nlm);
    for l=1:Nlm
        errorsHorizonU = su(:,l) - repmat(lmd_proj(1,l),mpc.N,1);
        errorsHorizon(1,l) = norm(errorsHorizonU);
        errorsHorizonV = sv(:,l) - repmat(lmd_proj(2,l),mpc.N,1);
        errorsHorizon(2,l) = norm(errorsHorizonV);
    end
    errors_horizon_all = [errors_horizon_all; errorsHorizon/sqrt(mpc.N)];

    % Real position of the landmarks with nonlinear model
    [lm_real_horizon] = real_landmarks(mpc, simdata, Tcm_cam, cm_height, Olm_w, pid_theta_com.state);

    plot_current
    
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