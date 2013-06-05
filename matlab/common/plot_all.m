format shortg;
clk = fix(clock);
clk=num2str(clk,'%0.2d');
clk(clk==' ')=[];
dir = ['tests/' clk];
mkdir(dir);

%limits_steps = [-0.2 2.2 -0.2 2.2];
print_res = 150; % pixels per inch
handlesAxesSteps = zeros(5,1);

% Plot result of the simulation (the positions that were actually used)
figure;
hold on
plot_parition_grid(grid);
handlesAxesSteps(1:3) = plot_steps_fixed_all(robot, simdata,handlesAxesSteps(3:5));
handlesAxesSteps(4:5) = plot_com_zmp_all(simdata);
plot(0,0,'or','MarkerSize',15,'MarkerFaceColor','y');

h_legend = legend(handlesAxesSteps,'Double support','Left support','Right support',...
           'CoM trajectory','CoP trajectory','Location','NorthWest');

pos = get(gcf,'PaperPosition');
set(gcf,'PaperPosition', [pos(1:2),30,30]);
print(gcf,'-depsc2',sprintf('-r%d',print_res), [dir '/steps.eps']);