more off
for stop_after_iter = [15];
    cd ../formulation_12
    walk_01_02;
    comDist_12 = comDist;
    cpProfile_12 = cpProfile;

    cd ../formulation_13
    walk_01_02;
    comDist_13 = comDist;
    cpProfile_13 = cpProfile;

    cd ../formulation_18
    walk_01_02;
    comDist_18 = comDist;
    cpProfile_18 = cpProfile;

    cd ../tests

    figure
    hold on
    plot(disturbProfile(1:length(comDist_12)), comDist_12, 'r')
    plot(disturbProfile(1:length(comDist_12)), comDist_12, 'ro')
    plot(disturbProfile, comDist_13, 'b');
    plot(disturbProfile, comDist_13, 'bd');
    plot(disturbProfile, comDist_18, 'k');
    plot(disturbProfile, comDist_18, 'kx');
    xlabel ('disturbance (meter/second)')
    ylabel ('divergence (meter)')
    hold off

    set(gca(),'xtick', get(gca(),'xtick') )
    set(gca(),'position', [0.15,0.15,0.75,0.75]);
    plotfilename = strcat('./divcom_vs_dist_', num2str(stop_after_iter), '.eps');
    print (plotfilename, '-deps', '-color', '-F:18');
    system(strcat('epstopdf ./', plotfilename));
    system(strcat('rm ./', plotfilename));

    figure
    hold on
    plot(disturbProfile(1:length(cpProfile_12)), cpProfile_12, 'r')
    plot(disturbProfile(1:length(cpProfile_12)), cpProfile_12, 'ro')
    plot(disturbProfile, cpProfile_13, 'b');
    plot(disturbProfile, cpProfile_13, 'bd');
    plot(disturbProfile, cpProfile_18, 'k');
    plot(disturbProfile, cpProfile_18, 'kx');
    xlabel ('disturbance (meter/second)')
    ylabel ('divergence (meter)')
    hold off

    set(gca(),'xtick', get(gca(),'xtick') )
    set(gca(),'position', [0.15,0.15,0.75,0.75]);
    plotfilename = strcat('./divcp_vs_dist_', num2str(stop_after_iter), '.eps');
    print (plotfilename, '-deps', '-color', '-F:18');
    system(strcat('epstopdf ./', plotfilename));
    system(strcat('rm ./', plotfilename));
end
more on
