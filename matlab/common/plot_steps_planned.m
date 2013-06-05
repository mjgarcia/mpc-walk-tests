function plot_steps_planned(robot, simdata)
    load_constants
    load_plotting_options


    for i=1:length(simdata.simstep(end).plannedSteps)
        if(simdata.simstep(end).plannedSteps(i).support_type == DS)
            support_rectangle = robot.ds_rectangle;
            fmt = DS_planned_fmt;
        else
            support_rectangle = robot.ss_rectangle;
            if(simdata.simstep(end).plannedSteps(i).support_type == LSS)
                fmt = LSS_planned_fmt;
            else
                fmt = RSS_planned_fmt;
            end
        end
        var_foot_pos = rotate_translate(support_rectangle, ...
            simdata.simstep(end).plannedSteps(i).R, ...
            simdata.simstep(end).plannedSteps(i).p);

        plot (var_foot_pos(1,:), var_foot_pos(2,:), fmt, 'linewidth', planned_linewidth);
    end
end
