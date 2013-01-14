function plot_com_zmp_all(simdata)
    load_plotting_options

    plot(simdata.zmpProfile(1,:), simdata.zmpProfile(2,:), zmp_trajectory_fmt, 'linewidth', 3)
    plot(simdata.cstateProfile(1,:), simdata.cstateProfile(4,:), com_trajectory_fmt, 'linewidth', 3);
end
