more off
for stop_after_iter = [10];
%    disturb_iter = 9;
    disturb_iter = 16;

    cd ../formulation_12
    walk_01_06;
    comDist_12 = comDist;
    cpvProfile_12 = cpvProfile;

    cd ../formulation_13
    walk_01_06;
    comDist_13 = comDist;
    cpvProfile_13 = cpvProfile;

    cd ../formulation_18
    walk_01_06;
    comDist_18 = comDist;
    cpvProfile_18 = cpvProfile;

    cd ../tests


    figure
    hold on
    plot(disturbProfile(fail_success_12 == 1), 1*ones(sum(fail_success_12 == 1), 1), '.b', 'markersize', 30);
    plot(disturbProfile(fail_success_12 == 0), 1*ones(sum(fail_success_12 == 0), 1), '.k', 'markersize', 30);
    plot(disturbProfile(fail_success_13 == 1), 2*ones(sum(fail_success_13 == 1), 1), '.b', 'markersize', 30);
    plot(disturbProfile(fail_success_13 == 0), 2*ones(sum(fail_success_13 == 0), 1), '.r', 'markersize', 30);
    plot(disturbProfile(fail_success_18 == 1), 3*ones(sum(fail_success_18 == 1), 1), '.b', 'markersize', 30);
    plot(disturbProfile(fail_success_18 == 0), 3*ones(sum(fail_success_18 == 0), 1), '.r', 'markersize', 30);
    set (gca(), 'ylim', [0,4])
    set (gca(), 'ytick', [1,2,3])
    set (gca(), 'yticklabel', 'TC|NTC|RTC')
    xlabel ('CoM velocity change (m/s)')
    ylabel ('MPC formulation')
    hold off

    print_plot(cstrcat('./fail_success_05_dist', num2str(disturb_iter)));

%{
    figure
    hold on
    plot(disturbProfile, comDist_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(comDist_12)), comDist_12, 'ro-', 'linewidth', 3, 'markersize', 7)
    xlabel ('CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    print_plot(cstrcat('./divcom_vs_dist_05_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_tc'));


    figure
    hold on
    plot(disturbProfile, comDist_13, 'bd-', 'linewidth', 3);
    xlabel ('CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    print_plot(cstrcat('./divcom_vs_dist_05_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_ntc'));
%}
end
