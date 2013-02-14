function print_plot(plot_file_name, crop_plot = false, apply_tick_fix = true)
    if (apply_tick_fix == true)
        set(gca(),'xtick', get(gca(),'xtick') )
        set(gca(),'position', [0.17,0.15,0.75,0.75]);
    end

    plot_file_name_eps = cstrcat(plot_file_name, '.eps');

    print (plot_file_name_eps, '-deps', '-color', '-F:18');
    system(cstrcat('epstopdf ', plot_file_name_eps));

    if (crop_plot == true)
        system(cstrcat('pdfcrop ', plot_file_name, '.pdf'));
        system(cstrcat('mv ', plot_file_name, '-crop.pdf  ', plot_file_name, '.pdf'));
    end

    system(cstrcat('rm ', plot_file_name_eps));
end
