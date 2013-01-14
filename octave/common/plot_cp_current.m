function plot_cp_current(simdata)
    load_plotting_options
    plot (simdata.cpProfile(1,end), simdata.cpProfile(2,end), capture_point_fmt, 'linewidth', capture_point_linewidth);
end
