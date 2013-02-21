clear;
more off
for stop_after_iter = [30];
    disturb_iter = 10;

    cd ../formulation_12
    walk_01_04;
    comDist_12 = comDist;
    cpvProfile_12 = cpvProfile;
    fail_success_12 = fail_success;

    cd ../formulation_13
    walk_01_04;
    comDist_13 = comDist;
    cpvProfile_13 = cpvProfile;
    fail_success_13 = fail_success;

    cd ../formulation_18
    walk_01_04;
    comDist_18 = comDist;
    cpvProfile_18 = cpvProfile;
    fail_success_18 = fail_success;

    cd ../tests

    figure
    hold on
    plot(disturbProfile(fail_success_12  < 0), 1*ones(sum(fail_success_12  < 0), 1), '.b', 'markersize', 30);
    plot(disturbProfile(fail_success_13  < 0), 2*ones(sum(fail_success_13  < 0), 1), '.b', 'markersize', 30);
    plot(disturbProfile(fail_success_18  < 0), 3*ones(sum(fail_success_18  < 0), 1), '.b', 'markersize', 30);

    plot(disturbProfile(fail_success_12  > 0), 1*ones(sum(fail_success_12  > 0), 1), '.k', 'markersize', 30);
    plot(disturbProfile(fail_success_13  > 0), 2*ones(sum(fail_success_13  > 0), 1), '.r', 'markersize', 30);
    plot(disturbProfile(fail_success_18  > 0), 3*ones(sum(fail_success_18  > 0), 1), '.r', 'markersize', 30);
    set (gca(), 'ylim', [0,4])
    set (gca(), 'ytick', [1,2,3])
    set (gca(), 'yticklabel', 'TC|NTC|RTC')
    xlabel ('CoM velocity change (m/s)')
    ylabel ('MPC formulation')
    hold off

    print_plot(cstrcat('./fail_success_03_dist', num2str(disturb_iter)));
%{
    figure
    hold on
    plot(disturbProfile, comDist_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(comDist_12)), comDist_12, 'ro-', 'linewidth', 3, 'markersize', 7)
    xlabel ('CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    set(gca(), 'xlim', [0.08, 0.19])
    if (disturb_iter == 9)
        set(gca(), 'ylim', [0.059, 0.061])
        set(gca(), 'ytick', [0.059, 0.06, 0.061])
    end
    print_plot(cstrcat('./divcom_vs_dist_03_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_tc'));


    figure
    hold on
    plot(disturbProfile, comDist_13, 'bd-', 'linewidth', 3);
    xlabel ('CoM velocity change (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    set(gca(), 'xlim', [0.08, 0.19])
    if (disturb_iter == 9)
        set(gca(), 'ylim', [0.059, 0.061])
        set(gca(), 'ytick', [0.059, 0.06, 0.061])
    end
    print_plot(cstrcat('./divcom_vs_dist_03_stop', num2str(stop_after_iter), '_dist', num2str(disturb_iter), '_ntc'));
%}
end
