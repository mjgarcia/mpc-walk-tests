function print_plot(plot_file_name, ...
    pp_options = struct('apply_tick_fix', true, 'pdf_crop', false, 'eps2eps', true, 'fontsize', 18))
% options
%   apply_tick_fix = true
%   pdf_crop = false
%   eps2eps = true
%   fontsize = 18


    if (isfield(pp_options, 'apply_tick_fix') && (pp_options.apply_tick_fix == true))
        set(gca(),'xtick', get(gca(),'xtick') )
        set(gca(),'position', [0.17,0.15,0.75,0.75]);
    end

    plot_file_name_eps = cstrcat(plot_file_name, '.eps');

    print (plot_file_name_eps, '-deps', '-color', cstrcat('-F:', num2str(pp_options.fontsize)));
    if (isfield(pp_options, 'eps2eps') && (pp_options.eps2eps == true))
        system(cstrcat('eps2eps ', plot_file_name_eps, ' ', plot_file_name_eps, '.tmp'));
        system(cstrcat('mv ', plot_file_name_eps, '.tmp ', plot_file_name_eps));
    end

    system(cstrcat('epstopdf ', plot_file_name_eps));

    if (isfield(pp_options, 'pdf_crop') && (pp_options.pdf_crop == true))
        system(cstrcat('pdfcrop ', plot_file_name, '.pdf'));
        system(cstrcat('mv ', plot_file_name, '-crop.pdf  ', plot_file_name, '.pdf'));
    end

    %system(cstrcat('rm ', plot_file_name_eps));
end
