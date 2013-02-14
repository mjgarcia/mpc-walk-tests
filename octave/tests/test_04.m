more off
for stop_after_iter = [10];
    disturb_iter = 16;

    cd ../formulation_12
    walk_01_05;
    comDist_12 = comDist;
    cpvProfile_12 = cpvProfile;

    cd ../formulation_13
    walk_01_05;
    comDist_13 = comDist;
    cpvProfile_13 = cpvProfile;

    cd ../formulation_18
    walk_01_05;
    comDist_18 = comDist;
    cpvProfile_18 = cpvProfile;

    cd ../tests


    figure
    hold on
    plot(disturbProfile, comDist_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(comDist_12)), comDist_12, 'ro-', 'linewidth', 3)
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    print_plot(cstrcat('./divcom_vs_dist_04_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_tc'));


    figure
    hold on
    plot(disturbProfile, comDist_13, 'bd-', 'linewidth', 3);
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    print_plot(cstrcat('./divcom_vs_dist_04_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_ntc'));



    figure
    hold on
    plot(disturbProfile, cpvProfile_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(cpvProfile_12)), cpvProfile_12, 'ro-', 'linewidth', 3)
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('velocity of capture point (m/s)')
    hold off

    print_plot(cstrcat('./divw_vs_dist_04_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_tc'));


    figure
    hold on
    plot(disturbProfile, cpvProfile_13, 'bd-', 'linewidth', 3);
    xlabel ('norm of CoM velocity change (m/s)')
    ylabel ('velocity of capture point (m/s)')
    hold off

    print_plot(cstrcat('./divw_vs_dist_04_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_ntc'));
end
