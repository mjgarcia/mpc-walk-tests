function handles = plot_com_zmp_all(simdata)
    load_plotting_options

    handles(1) = plot(simdata.cstateProfile(1,:), simdata.cstateProfile(4,:), com_trajectory_fmt, 'linewidth', 1);
    handles(2) = plot(simdata.zmpProfile(1,:), simdata.zmpProfile(2,:), zmp_trajectory_fmt, 'linewidth', 1);
end
