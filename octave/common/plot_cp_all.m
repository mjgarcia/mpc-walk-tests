function plot_cp_all(simdata)
    load_plotting_options
    plot (simdata.cpProfile(end-1,:), simdata.cpProfile(end,:), capture_point_fmt, 'linewidth', capture_point_linewidth);
end
