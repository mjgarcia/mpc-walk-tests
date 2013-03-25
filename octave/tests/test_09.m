cd ../formulation_18
walk_01_01
cd ../tests

cla
hold on
plot_steps_fixed_all(robot, simdata)

xlabel ('x (m)')
ylabel ('y (m)')

support_rectangle = robot.ss_rectangle;
fixed_foot_pos = rotate_translate(support_rectangle, simdata.fixedSteps(3).R, simdata.fixedSteps(3).p);
patch (fixed_foot_pos(1,:), fixed_foot_pos(2,:), [0.7 0.7 1], 'EdgeColor', 'none');

fixed_foot_pos = rotate_translate(support_rectangle, simdata.fixedSteps(3).R, simdata.fixedSteps(4).p);
patch (fixed_foot_pos(1,:), fixed_foot_pos(2,:), [1 0.7 0.7], 'EdgeColor', 'none');

fixed_foot_pos = rotate_translate(support_rectangle, simdata.fixedSteps(3).R, simdata.fixedSteps(5).p);
patch (fixed_foot_pos(1,:), fixed_foot_pos(2,:), [1 0.7 0.7], 'EdgeColor', 'none');

fixed_foot_pos = rotate_translate(support_rectangle, simdata.fixedSteps(3).R, simdata.fixedSteps(6).p);
patch (fixed_foot_pos(1,:), fixed_foot_pos(2,:), [1 0.7 0.7], 'EdgeColor', 'none');

plot_com_zmp_all(simdata)
hold off 
axis equal

print_plot('3steps');
