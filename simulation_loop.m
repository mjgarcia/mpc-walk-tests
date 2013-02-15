addpath('/home/mauricio/Developer/mpc-walk-tests-mg_branch/matlab/common')

parameters_robot
parameters_mpc6

init_walk_01

simdata = init_simdata(mpc, mpc_state);

init_visual_servoing

figFootSteps = figure;
while (1)
    
    % form matrices
    [Nfp, V0c, V] = form_foot_pos_matrices(mpc, mpc_state);
    [S0, U, S0p, Up, S0v, Uv, S0z, Uz] = form_condensing_matrices(mpc, mpc_state);
    
    % Form objective and constraints
    [H, q] = form_objective (mpc, mpc_state, S0v, Uv, S0z, Uz, V0c, V, Nfp);
    
    % Update global transformations
    [Tw_cm, Tcm_w, Tw_cam] = updateGlobalTransformations(mpc_state,Tcm_cam,cm_height);
    figure(fig3DSim);
    drawAxis(Tcm_w);
    
    % Position of the landmark in camera frame
    Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
    % Real landmarks projected
    lm_proj = projectToImagePlane(Olm_cam);
    figure(fig2DProj);
    plot(lm_proj(1,:),lm_proj(2,:),'.b','MarkerSize',5);
    
    % Linearize projection around current landmark positions
    matProjLin = linearizeProjection(Olm_cam);
          
    % Compute visual servoing matrices
    [Du Dv Cu Cv vs_params] = visual_servoing_matrices(mpc,matProjLin,Tcm_cam,Tcm_w,Tw_cam,Olm_w);
    
    %lm_proj_lin = matProjLin*Olm_cam;
    %plot(lm_proj_lin(2,:),-lm_proj_lin(1,:),'.r');
    su = zeros(Nlm);
    sv = zeros(Nlm);

    for l=1:Nlm
        su(l) = vs_params.au*Tcm_w(1,4) + vs_params.bu*Tcm_w(2,4) + vs_params.cu(l);
        sv(l) = vs_params.av*Tcm_w(1,4) + vs_params.bv*Tcm_w(2,4) + vs_params.cv(l);
    end
    plot(su,sv,'.r','MarkerSize',3);
    
    % Add visual servoing parameters to the objective
    [H, q] = addVisualServoingToObjective(mpc, H, q, Du, Dv, Cu, Cv, lmd_proj, weightsMatrix, S0p, Up);
    
    % TODO: Visual servoing contraints
    
    [Gzmp, Gzmp_ub] = form_zmp_constraints(robot, mpc, mpc_state, V0c, V, S0z, Uz);
    [Gfd, Gfd_ub] = form_fd_constraints (robot, mpc, mpc_state, Nfp);

    % Combine constraints:
    %   Ge * X = ge
    %   G * X <= G_ub
    [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (Gzmp, Gzmp_ub, Gfd, Gfd_ub, [], [], [], []);

    % run solver
    tic;
    %options = optimset('LargeScale','off','Display','off');
    options = optimset('LargeScale','off');
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
    for l=1:Nlm
        plot(su(:,l),sv(:,l),'.-g','MarkerSize',5);
    end
    
    % Real position of the landmarks with nonlinear model
    [lm_real_horizon] = real_landmarks(mpc, simdata, Tcm_cam, cm_height, Olm_w);
    for k=1:mpc.N
        plot(lm_real_horizon(1,:,k),lm_real_horizon(2,:,k),'.r','MarkerSize',5);
    end
    
% plot
    % Plotting during simulation, comment the following lines out, if you want it to work faster.
    figure(figFootSteps);
    hold on
    plot_steps_fixed_current(robot, simdata);
    plot_steps_planned(robot, simdata);
    plot_com_zmp_planned(mpc, simdata);
    hold off


% next
    [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata);
    if (mpc_state.stop == 1);
        disp('Not enough data to form preview window');
        break;
    end

    % Without this line Octave does not plot results during simulation.
    pause(0.1);
end

% Plot result of the simulation (the positions that were actually used)
figure
hold on
plot_com_zmp_all(simdata);
plot_steps_fixed_all(robot, simdata);
hold off
