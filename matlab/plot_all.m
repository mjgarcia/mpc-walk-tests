format shortg;
clk = fix(clock);
clk=num2str(clk,'%0.2d');
clk(clk==' ')=[];
dir = ['tests/' clk];
mkdir(dir);

    limits_features = [-0.4 1.6 -0.3 0.7];
    limits_steps = [-0.2 2.6 -0.1 1.2];
    
% Features trajectories
clf;
subplot(2,1,1);
handles1 = zeros(3,1);
handles1(1) = plot([-lm_proj_init(2,:) -lm_proj_init(2,1)],[-lm_proj_init(1,:) -lm_proj_init(1,1)],'-g');
axis(limits_features);
hold('on');
handles1(2) = plot([-lmd_proj(2,:) -lmd_proj(2,1)],[-lmd_proj(1,:) -lmd_proj(1,1)],'-r');
handles1(3) = plot(-lm_proj_all(2:2:end,1),-lm_proj_all(1:2:end,1),'-b');
for l=2:Nlm
    plot(-lm_proj_all(2:2:end,l),-lm_proj_all(1:2:end,l),'-b');
end
h_legend = legend(handles1,'Initial position','Final position','Trajectory','Location','NorthWest');
set(h_legend,'FontSize',8);
% Plot result of the simulation (the positions that were actually used)
subplot(2,1,2);
handlesAxesSteps = zeros(5,1);
hold on
handlesAxesSteps(1:2) = plot_com_zmp_all(simdata);
axis(limits_steps);
handlesAxesSteps(3:5) = plot_steps_fixed_all(robot, simdata,handlesAxesSteps(3:5));
h_legend = legend(handlesAxesSteps,'CoM trajectory','CoP trajectory',...
           'Double support','Single left','Single right',...
           'Location','NorthWest');
set(h_legend,'FontSize',8);
print_res = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1800 1400]/print_res);
print(gcf,'-dbmp16m',sprintf('-r%d',print_res), ['video/imgFinal.bmp']);
%print(gcf,'-dpng',sprintf('-r%d',print_res), 'video/imgFinal.png');

% Features trajectories
figure;
plot([-lm_proj_init(2,:) -lm_proj_init(2,1)],[-lm_proj_init(1,:) -lm_proj_init(1,1)],'-r');
axis(limits_features);
hold('on');
plot([-lmd_proj(2,:) -lmd_proj(2,1)],[-lmd_proj(1,:) -lmd_proj(1,1)],'-m');
for l=1:Nlm
    plot(-lm_proj_all(2:2:end,l),-lm_proj_all(1:2:end,l),'-b');
end
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/features.eps']);

% Plot result of the simulation (the positions that were actually used)
figure;
hold on
plot_com_zmp_all(simdata);
axis(limits_steps);
plot_steps_fixed_all(robot, simdata,handlesAxesSteps(3:5));
pos = get(gcf,'PaperPosition');
set(gcf,'PaperPosition', [pos(1:2),8,4]);
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/steps.eps']);


% Evolution of velocities
len = length(simdata.cstateProfile(2,1:end-1));
time = 0.0:mpc.T:mpc.T*(len-1);
figure;
plot(time,simdata.cstateProfile(2,1:end-1),'r');
hold('on');
plot(time,simdata.cstateProfile(5,1:end-1),'b');
plot(time,pid_theta_com.vel_all(1:end-1),'m');
hline = refline([0 0]);
set(hline,'Color','k','LineStyle','--');
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/velocities.eps']);

% Evolution of cost functions
figure;
plot(time,obj_all,'b');
hline = refline([0 0]);
set(hline,'Color','k','LineStyle','--');
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/objective.eps']);

% Evolution of the instantaneus errors
figure;
hold('on');
for l=1:Nlm
    plot(time,lm_proj_errors_all(1:2:end,l),'LineStyle','--','Color',colors(l,:));
    plot(time,lm_proj_errors_all(2:2:end,l),'LineStyle','-.','Color',colors(l,:));
end
hline = refline([0 0]);
set(hline,'Color','k','LineStyle','--');
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/instantaneus_errors.eps']);

% Evolution of the errors in the horizon
figure;
hold('on');
for l=1:Nlm
    plot(time,errors_horizon_all(1:2:end,l),'LineStyle','--','Color',colors(l,:));
    plot(time,errors_horizon_all(2:2:end,l),'LineStyle','-.','Color',colors(l,:));
end
hline = refline([0 0]);
set(hline,'Color','k','LineStyle','--');
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/horizon_errors.eps']);