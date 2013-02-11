function plot_cp_planned(simdata)
    load_plotting_options
    plot (simdata.cpProfile(end-1,end), simdata.cpProfile(end,end), capture_point_fmt, 'linewidth', capture_point_linewidth);
end
