function [handles] = plot_steps_fixed_current(robot, simdata,handles)
    load_constants
    load_plotting_options

    if (simdata.fixedSteps(end).support_type == DS);
        support_rectangle = robot.ds_rectangle;
        fmt = DS_fixed_fmt;
        index = 1;
    else
        support_rectangle = robot.ss_rectangle;
        if (simdata.fixedSteps(end).support_type == LSS)
            index = 2;
            fmt = LSS_fixed_fmt;
        else
            index = 3;
            fmt = RSS_fixed_fmt;
        end
    end
    fixed_foot_pos = rotate_translate(support_rectangle, simdata.fixedSteps(end).R, simdata.fixedSteps(end).p);
    tmp_handle = plot (fixed_foot_pos(1,:), fixed_foot_pos(2,:), fmt, 'linewidth', fixed_linewidth);
    if handles(index) == 0
       handles(index) = tmp_handle;
    end
end
