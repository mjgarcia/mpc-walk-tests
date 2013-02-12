stop_after_iter = [10,15,20,25]; %0:7;
more off
for disturb_multiplier = 4:5;
    cd ../formulation_13
    walk_01_03;
    comDist_13 = comDist;

    cd ../formulation_18
    walk_01_03;
    comDist_18 = comDist;

    figure
    hold on
    plot(stop_after_iter, comDist_13, 'b');
    plot(stop_after_iter, comDist_13, 'bd');
    plot(stop_after_iter, comDist_18, 'k');
    plot(stop_after_iter, comDist_18, 'kx');
    xlabel ('iteration after disturbance')
    ylabel ('divergence (meter)')
    hold off

    cd ../tests
    set(gca(),'xtick', get(gca(),'xtick') )
    %axpos = get(gca(),'position');
    %set(gca(),'position', axpos);
    set(gca(),'position', [0.15,0.15,0.75,0.75]);
    plotfilename = strcat('./div_iter_', num2str(disturb_multiplier), '.eps');
    print (plotfilename, '-deps', '-color', '-F:18');
    system(strcat('epstopdf ./', plotfilename));
    system(strcat('rm ./', plotfilename));
end
more on
