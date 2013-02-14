more off
for stop_after_iter = [10];
    cd ../formulation_12
    walk_01_02;
    comDist_12 = comDist;
    wProfile_12 = wProfile;

    cd ../formulation_13
    walk_01_02;
    comDist_13 = comDist;
    wProfile_13 = wProfile;

    cd ../formulation_18
    walk_01_02;
    comDist_18 = comDist;
    wProfile_18 = wProfile;

    cd ../tests


    figure
    hold on
    plot(disturbProfile, comDist_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(comDist_12)), comDist_12, 'ro-', 'linewidth', 3)
    xlabel ('change of CoM velocity (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    set(gca(),'xtick', get(gca(),'xtick') )
    set(gca(),'position', [0.15,0.15,0.75,0.75]);
    plotfilename = strcat('./divcom_vs_dist_', num2str(stop_after_iter), '_tc.eps');
    print (plotfilename, '-deps', '-color', '-F:18');
    system(strcat('epstopdf ./', plotfilename));
    system(strcat('rm ./', plotfilename));


    figure
    hold on
    plot(disturbProfile, comDist_13, 'bd-', 'linewidth', 3);
    xlabel ('change of CoM velocity (m/s)')
    ylabel ('distance between CoM and support (m)')
    hold off

    set(gca(),'xtick', get(gca(),'xtick') )
    set(gca(),'position', [0.15,0.15,0.75,0.75]);
    plotfilename = strcat('./divcom_vs_dist_', num2str(stop_after_iter), '_ntc.eps');
    print (plotfilename, '-deps', '-color', '-F:18');
    system(strcat('epstopdf ./', plotfilename));
    system(strcat('rm ./', plotfilename));



    figure
    hold on
    plot(disturbProfile, wProfile_18, 'kx-', 'linewidth', 3);
    plot(disturbProfile(1:length(wProfile_12)), wProfile_12, 'ro-', 'linewidth', 3)
    xlabel ('change of CoM velocity (m/s)')
    ylabel ('velocity of capture point (m/s)')
    hold off

    set(gca(),'xtick', get(gca(),'xtick') )
    set(gca(),'position', [0.17,0.15,0.75,0.75]);
    plotfilename = strcat('./divw_vs_dist_', num2str(stop_after_iter), '_tc.eps');
    print (plotfilename, '-deps', '-color', '-F:18');
    system(strcat('epstopdf ./', plotfilename));
    system(strcat('rm ./', plotfilename));


    figure
    hold on
    plot(disturbProfile, wProfile_13, 'bd-', 'linewidth', 3);
    xlabel ('change of CoM velocity (m/s)')
    ylabel ('velocity of capture point (m/s)')
    hold off

    set(gca(),'xtick', get(gca(),'xtick') )
    set(gca(),'position', [0.17,0.15,0.75,0.75]);
    plotfilename = strcat('./divw_vs_dist_', num2str(stop_after_iter), '_ntc.eps');
    print (plotfilename, '-deps', '-color', '-F:18');
    system(strcat('epstopdf ./', plotfilename));
    system(strcat('rm ./', plotfilename));
end
more on
