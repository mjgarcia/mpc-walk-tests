function plot_steps_planned_convhull(robot, simdata)
    load_constants
    load_plotting_options

    if (simdata.fixedSteps(end).support_type == DS);
        support_rectangle = robot.ds_rectangle;
    else
        support_rectangle = robot.ss_rectangle;
    end
    vertices = rotate_translate(support_rectangle, simdata.fixedSteps(end).R, simdata.fixedSteps(end).p);


    for i=1:length(simdata.simstep(end).plannedSteps)
        if(simdata.simstep(end).plannedSteps(i).support_type == DS)
            support_rectangle = robot.ds_rectangle;
        else
            support_rectangle = robot.ss_rectangle;
        end

        vertices = [vertices, ...
            rotate_translate(support_rectangle, ...
                simdata.simstep(end).plannedSteps(i).R, ...
                simdata.simstep(end).plannedSteps(i).p)];
    end

    vert_ind = convhull(vertices(1,:), vertices(2,:));
    plot (vertices(1,vert_ind), vertices(2,vert_ind), 'y');
end
