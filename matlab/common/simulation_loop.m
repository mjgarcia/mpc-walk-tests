clear;
clc;

parameters_robot
parameters_mpc6
parameters_mpc_rot
init_walk_01

initPos = [-2; 1];
mpc_state.cstate = [initPos(1); 0; 0; initPos(2); 0; 0];  % Initial CoM state
mpc_state.p = initPos;                   % Position of the initial support

parameters_planner

simdata = init_simdata(mpc, mpc_state);

mpc_state_rot.cstate = [0; 0; 0; 0; 0; 0];

theta_max_feet_trunk = deg2rad(10*ones(mpc_rot.N,1));
handlesAxesSteps = zeros(5,1);

grid = load_orientations_grid();

quiver(grid.scale*grid.x,grid.scale*grid.y,grid.df_dx,grid.df_dy);

figure;
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
    dangle
    
    mpc_state_rot.ref_pos = angle_optimal;
    disp(['angle ' num2str(radtodeg(mpc_state_rot.ref_pos))]);
    
    if(any(abs(dangle) > 1)) 
        dangle = prev_dangle;
    end
    prev_dangle = dangle;
    dangle

    % form matrices
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S, S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);

    [S0_rot, S0p_rot, S0v_rot, S0a_rot, D1, D2] = form_condensing_matrices_rot(mpc_rot, mpc_state_rot, S);

    % Rotation angle optimization
    [H_rot, q_rot, S0p_rot, Up_rot] = form_objective_rot (mpc_rot, mpc_state_rot, S0p_rot, Up, S0v_rot, Uv, D1, D2);

    [G_rot, G_rot_ub] = form_rot_constraints (D1, D2, Up, S0p_rot, theta_max_feet_trunk);

    options = optimset('LargeScale','off');
    %[X_rot, fval] = quadprog (H_rot, q_rot,G_rot,G_rot_ub,[],[],[],-1000*ones(2*mpc.N,1),1000*ones(2*mpc.N,1),options);
    [X_rot, fval] = quadprog (H_rot, q_rot,G_rot,G_rot_ub,[],[],[],[],[],options);

    %cState_rot_p = S0p_rot + Up*X_rot;
    cState_rot = S0_rot + U*X_rot;
    mpc_state_rot.cstate = cState_rot(1:6);
    %disp(['rot ' num2str(mpc_state_rot.cstate')]);
    radtodeg(mpc_state_rot.cstate)
    
    % Rotaion of the foot steps
    [mpc_state] = update_rotation_zmp(mpc, mpc_state, cState_rot(1:6:end));

    [AB0xy Vel0] =  form_planner_matrices(planner,mpc,mpc_state_rot.ref_pos,dangle,p_current);
    
    % Form objective and constraints
    [H, q] = form_objective (mpc,S0p, Up, S0v, Uv, S0z, Uz, V0c, V, AB0xy, Vel0, Nfp);

    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);

    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);

    % Combine constraints:
    %   Ge * X = ge
    %   G * X <= G_ub
    [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, [], [], [], []);

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

    plot_current

% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        disp('Not enough data to form preview window');
        break;
    end

    % Without this line Octave does not plot results during simulation.
    pause(0.01);

end

plot_all
