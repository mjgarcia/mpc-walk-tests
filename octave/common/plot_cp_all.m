function plot_cp_current(simdata)
    load_plotting_options
    plot (simdata.cpProfile(1,:), simdata.cpProfile(2,:), capture_point_fmt, 'linewidth', capture_point_linewidth);
end
