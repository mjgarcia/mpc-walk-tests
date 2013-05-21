format shortg;
clk = fix(clock);
clk=num2str(clk,'%0.2d');
clk(clk==' ')=[];
dir = ['tests/' clk];
mkdir(dir);

limits_steps = [-0.2 2.2 -0.2 2.2];
print_res = 150; % pixels per inch
% Plot result of the simulation (the positions that were actually used)
figure;
hold on
plot(x_plann_all,y_plann_all,'LineWidth',2);
plot_com_zmp_all(simdata);
axis(limits_steps);
plot_steps_fixed_all(robot, simdata,handlesAxesSteps(3:5));
pos = get(gcf,'PaperPosition');
set(gcf,'PaperPosition', [pos(1:2),8,4]);
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/steps.eps']);