%stop_after_iter = [10,15,20,25]; %0:7;
stop_after_iter = 0:7;
more off
for disturb_multiplier = 4:5;
    cd ../formulation_13
    walk_01_03;
    comDist_13 = comDist;
    cpVelProfile_13 = cpVelProfile;

    cd ../formulation_18
    walk_01_03;
    comDist_18 = comDist;
    cpVelProfile_18 = cpVelProfile;

    figure
    hold on
    plot(stop_after_iter, comDist_13, 'bd-');
    plot(stop_after_iter, comDist_18, 'kx-');
    xlabel ('iteration after disturbance')
    ylabel ('divergence (meter)')
    hold off

    cd ../tests
    print_plot(xstrcat('./div_iter_', num2str(disturb_multiplier));

    figure
    hold on
    plot(stop_after_iter, cpVelProfile_13, 'bd-');
    plot(stop_after_iter, cpVelProfile_18, 'kx-');
    xlabel ('disturbance (meter/second)')
    ylabel ('divergence (meter)')
    hold off
end
