%limits_steps = [-0.2 2.2 -0.2 2.2];

% plot
% Plotting during simulation, comment the following lines out, if you
% want it to work faster.
%axis(limits_steps);
hold on
handlesAxesSteps(1:2) = plot_com_zmp_planned(mpc, simdata);
handlesAxesSteps(3:5) = plot_steps_fixed_current(robot, simdata,handlesAxesSteps(3:5));
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