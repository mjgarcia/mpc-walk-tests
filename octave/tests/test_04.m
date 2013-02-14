more off
for stop_after_iter = [10];
    cd ../formulation_12
    walk_01_05;
    comDist_12 = comDist;
    wProfile_12 = wProfile;

    cd ../formulation_13
    walk_01_05;
    comDist_13 = comDist;
    wProfile_13 = wProfile;

    cd ../formulation_18
    walk_01_05;
    comDist_18 = comDist;
    wProfile_18 = wProfile;

    cd ../tests


    figure
    hold on
    plot(disturbProfile, comDist_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(comDist_12)), comDist_12, 'ro-', 'linewidth', 3)
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    print_plot(cstrcat('./divcom_vs_dist_04_', num2str(stop_after_iter), '_tc'));


    figure
    hold on
    plot(disturbProfile, comDist_13, 'bd-', 'linewidth', 3);
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    print_plot(cstrcat('./divcom_vs_dist_04_', num2str(stop_after_iter), '_ntc'));



    figure
    hold on
    plot(disturbProfile, wProfile_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(wProfile_12)), wProfile_12, 'ro-', 'linewidth', 3)
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('velocity of capture point (m/s)')
    hold off

    print_plot(cstrcat('./divw_vs_dist_04_', num2str(stop_after_iter), '_tc'));


    figure
    hold on
    plot(disturbProfile, wProfile_13, 'bd-', 'linewidth', 3);
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('velocity of capture point (m/s)')
    hold off

    print_plot(cstrcat('./divw_vs_dist_04_', num2str(stop_after_iter), '_ntc'));
end
