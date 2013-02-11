function plot_cp_all_planned(simdata)
    load_plotting_options
    plot (simdata.cpProfile(1:2:end,end), simdata.cpProfile(2:2:end,end), capture_point_fmt, 'linewidth', capture_point_linewidth);
end
