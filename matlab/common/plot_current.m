%limits_features = [-0.4 1.6 -0.3 0.7];
%limits_steps = [-0.2 2.6 -0.1 1.2];

subplot(1,2,1);
handles1 = zeros(6,1);
%axis(limits_features);
plot([vs_limits.u_min vs_limits.u_max vs_limits.u_max vs_limits.u_min vs_limits.u_min],[vs_limits.v_min vs_limits.v_min vs_limits.v_max vs_limits.v_max vs_limits.v_min],'-r');
hold('on');
handles1(1) = plot(-lm_proj_all(2:2:end,1),-lm_proj_all(1:2:end,1),'-b');
for l=2:Nlm
    plot(-lm_proj_all(2:2:end,l),-lm_proj_all(1:2:end,l),'-b');
end
handles1(2) = plot([-sv(1,:) -sv(1,1)],[-su(1,:) -su(1,1)],':b');

tmpU = lm_real_horizon(1,1,:);
tmpV = lm_real_horizon(2,1,:);
tmpU = reshape(tmpU,[1 mpc.N]);
tmpV = reshape(tmpV,[1 mpc.N]);
handles1(5) = plot(-tmpV,-tmpU,'-c');
for l=2:Nlm
    tmpU = lm_real_horizon(1,l,:);
    tmpV = lm_real_horizon(2,l,:);
    tmpU = reshape(tmpU,[1 mpc.N]);
    tmpV = reshape(tmpV,[1 mpc.N]);
    plot(-tmpV,-tmpU,'-c');
end
handles1(6) = plot([-lm_real_horizon(2,:,mpc.N) -lm_real_horizon(2,1,mpc.N)],[-lm_real_horizon(1,:,mpc.N) -lm_real_horizon(1,1,mpc.N)],':c');

%plot(suNoisy(:,l),svNoisy(:,l),'.-k','MarkerSize',5);
handles1(4) = plot(-sv(:,1),-su(:,1),'-m');
for l=2:Nlm
    plot(-sv(:,l),-su(:,l),'-m');
    %plot(suNoisy(:,l),svNoisy(:,l),'.-k','MarkerSize',5);
end
handles1(4) = plot([-sv(end,:) -sv(end,1)],[-su(end,:) -su(end,1)],':m');

% h_legend = legend(handles1,'Trajectory so far','Current position',...
% 'Trajectory horizon linearized','Final position horizon linearized','Trajectory horizon non-linearized',...
% 'Final position horizon non-linearized','Location','NorthWest');
%  %set(h_legend,'units','pixels');
%  %lp=get(h_legend,'outerposition');
%  %set(h_legend,'outerposition',[lp(1:2),0.1,0.1]);
%  set(h_legend,'FontSize',8);

%     % Perturbation of the center of mass
%     if it == itPert
%     [Tw_cm, Tcm_w, Tw_cam, Tcam_w, Tcm_cam] = updateGlobalTransformations(com_undist,cm_height,theta_cam,pid_theta_com.state);
%     % Position of the landmark in camera frame
%     Olm_cam = Tw_cam*[Olm_w;ones(1,Nlm)];
%     % Real landmarks projected
%     lm_proj = projectToImagePlane(Olm_cam);
%     plot([-lm_proj(2,:) -lm_proj(2,1)],[-lm_proj(1,:) -lm_proj(1,1)],'-b');
%     disp('Perturbation');
%     pause;
%     end

hold('off');

% plot
% Plotting during simulation, comment the following lines out, if you
% want it to work faster.
subplot(1,2,2);
%axis(limits_steps);
hold on
handlesAxesSteps(1:2) = plot_com_zmp_planned(mpc, simdata);
%handlesAxesSteps(3:5) = plot_steps_fixed_current(robot, simdata,handlesAxesSteps(3:5));
handlesAxesSteps(3:5) = plot_steps_planned(robot, simdata,handlesAxesSteps(3:5));
h_legend = legend(handlesAxesSteps,'CoM trajectory','CoP trajectory',...
            'Double support','Single left','Single right',...
            'Location','NorthWest');
set(h_legend,'FontSize',8);
print_res = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1800 1400]/print_res);
%print(gcf,'-dpng',sprintf('-r%d',print_res), ['video/img' num2str(it,'%0.3i') '.png']);
%print(gcf,'-dbmp16m',sprintf('-r%d',print_res), ['video/img' num2str(it,'%0.3i') '.bmp']);
hold off