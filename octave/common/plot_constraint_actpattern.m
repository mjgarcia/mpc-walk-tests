function plot_constraint_actpattern(simdata)
    load_constants
    load_plotting_options

    binmat = [];
    for i=1:length(simdata.simstep)
        binmat = [binmat, (simdata.simstep(i).lambda_zmp != 0)];
    end

    spy(binmat, 15);
    xlabel('iteration of simulation');
    ylabel('number of constraint');
    axis('xy');
    grid on;
%    axis equal;
end
