function plot_fixed_all(robot, simdata)
    load_constants
    load_plotting_options


    for i = 1:length(simdata.fixedSteps)
        if (simdata.fixedSteps(i).support_type == DS);
            support_rectangle = robot.ds_rectangle;
            fmt = DS_fixed_fmt;
        else
            support_rectangle = robot.ss_rectangle;
            if (simdata.fixedSteps(i).support_type == LSS)
                fmt = LSS_fixed_fmt;
            else
                fmt = RSS_fixed_fmt;
            end
        end
        fixed_foot_pos = rotate_translate(support_rectangle, simdata.fixedSteps(i).R, simdata.fixedSteps(i).p);
        plot (fixed_foot_pos(1,:), fixed_foot_pos(2,:), fmt, 'linewidth', fixed_linewidth);
    end
end
