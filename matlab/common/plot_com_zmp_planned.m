function handles = plot_com_zmp_planned(mpc, simdata)
    handles = zeros(2,1);
    load_plotting_options
    handles(1) = plot (simdata.cstateProfile(1:mpc.Ns:end, end), simdata.cstateProfile(4:mpc.Ns:end, end), com_trajectory_fmt);
    handles(2) = plot (simdata.zmpProfile(1:2:end, end), simdata.zmpProfile(2:2:end, end), zmp_trajectory_fmt);
end
