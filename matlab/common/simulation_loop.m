clear;
clc;

parameters_robot
parameters_mpc6
parameters_mpc_rot

initPos = [-2; 1; degtorad(-65)];
%initPos = [-2; 4.5; degtorad(-100)];
mpc_state.cstate = [initPos(1); 0; 0; initPos(2); 0; 0];  % Initial CoM state
mpc_state.p = initPos(1:2);                               % Position of the initial support

init_walk_01

parameters_planner

simdata = init_simdata(mpc, mpc_state);

init_visual_servoing

mpc_state_rot.cstate = [initPos(3); 0; 0; initPos(3); 0; 0];

mpc_state_rot.theta_max_feet_com = deg2rad(10*ones(mpc_rot.N,1));
mpc_state_rot.theta_margin = degtorad(0);
mpc_state_rot.max_vel = 100;

handlesAxesSteps = zeros(5,1);

grid = load_orientations_grid();

%quiver(grid.scale*grid.x,grid.scale*grid.y,grid.df_dx,grid.df_dy);
lm_proj_all = [];

subplot(1,2,2);
quiver(grid.scale*grid.x,grid.scale*grid.y,cos(grid.orientations),sin(grid.orientations));
hold('on');

it = 0;
while (1)
    it = it + 1;

    p_current = [mpc_state.cstate(1); mpc_state.cstate(4)];
    indexGrid = index_in_grid(grid,p_current);
    
    angle_optimal = grid.orientations(indexGrid(1),indexGrid(2));    
    dangle(1) = grid.df_dx(indexGrid(1),indexGrid(2));
    dangle(2) = grid.df_dy(indexGrid(1),indexGrid(2));
    
    mpc_state_rot.ref_pos = angle_optimal;
    disp(['angle ' num2str(radtodeg(mpc_state_rot.ref_pos))]);
    
    if(any(abs(dangle) > 1)) 
        dangle = prev_dangle;
    end
    prev_dangle = dangle;

    % form matrices
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S, S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);

    [S0_rot, S0p_rot, S0v_rot, S0a_rot, D1, D2] = form_condensing_matrices_rot(mpc_rot, mpc_state_rot, S);

    % Rotation angle optimization
    [H_rot, q_rot, S0p_rot, Up_rot] = form_objective_rot (mpc_rot, mpc_state_rot, S0p_rot, Up, S0v_rot, Uv, D1, D2);

    [G_rot, G_rot_ub] = form_rot_constraints (mpc_rot, mpc_state_rot, D1, D2, Up, S0p_rot, Uv, S0v_rot);

    options = optimset('LargeScale','off');
    %[X_rot, fval] = quadprog (H_rot, q_rot,G_rot,G_rot_ub,[],[],[],-1e20*ones(2*mpc.N,1),1e20*ones(2*mpc.N,1),options);
    [X_rot, fval] = quadprog (H_rot, q_rot,G_rot,G_rot_ub,[],[],[],[],[],options);

    %cState_rot_p = S0p_rot + Up*X_rot;
    cState_rot = S0_rot + U*X_rot;
    mpc_state_rot.cstate = cState_rot(1:6);
    radtodeg(cState_rot(4:6:end))
    
    %disp(['rot ' num2str(mpc_state_rot.cstate')]);
    radtodeg(mpc_state_rot.cstate)
    
      % Update global transformations
    [Tw_cm, Tcm_w, Tw_cam, Tcam_w, Tcm_cam] = updateGlobalTransformations(mpc_state.cstate,robot.h,mpc_state_rot.cstate(1),mpc_state_rot.cstate(1));

    % Position of the landmark in camera frame
    Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
    Olm_cam 
    
    % Real landmarks projected
    lm_proj = projectToImagePlane(Olm_cam);
    lm_proj
    
    %Add noise
    %sigma = 0.0001;
    %sigma = 0.0;
    %lm_proj_noisy = lm_proj + sigma*randn(size(lm_proj));
    lm_proj_all = [lm_proj_all; lm_proj];
    %lm_proj_errors_all = [lm_proj_errors_all; abs(lm_proj - lmd_proj)];

    % Linearize projection around current landmark positions
    matProjLin = linearizeProjection(Olm_cam,Nlm);

    % Compute visual servoing matrices
    [Du Dv Cu Cv vs_params] = visual_servoing_matrices(mpc,matProjLin,Tcm_cam,Tcm_w,Tw_cam,Olm_w,Nlm);

    %lm_proj_lin = matProjLin*Olm_cam;
    %plot(lm_proj_lin(2,:),-lm_proj_lin(1,:),'.r');
    su = zeros(Nlm);
    sv = zeros(Nlm);

    for l=1:Nlm
        su(l) = vs_params.au(l)*Tcm_w(1,4) + vs_params.bu(l)*Tcm_w(2,4) + vs_params.cu(l);
        sv(l) = vs_params.av(l)*Tcm_w(1,4) + vs_params.bv(l)*Tcm_w(2,4) + vs_params.cv(l);
    end
    %plot(su,sv,'.r','MarkerSize',4);
    
    % Rotaion of the foot steps
    [mpc_state] = update_rotation_zmp(mpc, mpc_state, cState_rot(4:6:end));

    [AB0xy Vel0] =  form_planner_matrices(planner,mpc,mpc_state_rot.ref_pos,dangle,p_current);
    
    % Form objective and constraints
    [H, q] = form_objective (mpc,S0p, Up, S0v, Uv, S0z, Uz, V0c, V, AB0xy, Vel0, Nfp);

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

    [X, OBJ, EXITFLAG, OUTPUT, LAMBDA] = quadprog (H, q, G, G_ub, Ge, ge,[],[],[],options);
    exec_time = toc();

    if (EXITFLAG ~= 1);
        disp('QP failed');
        %keyboard;
    end

    % Collect data.
    [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, LAMBDA, lambda_mask, exec_time, simdata);

    
    % Simulate position of the landmarks with linear model
    [su sv] = simulate_landmarks(mpc, simdata, vs_params);
    %[suNoisy svNoisy] = simulate_landmarks(mpc, simdata, vs_paramsNoisy);

    % Real position of the landmarks with nonlinear model
    [lm_real_horizon] = real_landmarks(mpc, simdata, Tcm_cam, robot.h, Olm_w, mpc_state_rot.cstate(1));


    plot_current

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        disp('Not enough data to form preview window');
        break;
    end

    % Without this line Octave does not plot results during simulation.
    if it == 37
    pause(0.01);
    end

end

plot_all
