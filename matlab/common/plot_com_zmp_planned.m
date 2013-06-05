function plot_com_zmp_planned(mpc, simdata)
    load_plotting_options
    plot (simdata.cstateProfile(1:mpc.Ns:end, end), simdata.cstateProfile(4:mpc.Ns:end, end), com_trajectory_fmt);
    plot (simdata.zmpProfile(1:2:end, end), simdata.zmpProfile(2:2:end, end), zmp_trajectory_fmt);
end
