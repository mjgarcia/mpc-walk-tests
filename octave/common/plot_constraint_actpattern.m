function plot_constraint_actpattern(simdata)
    load_constants
    load_plotting_options

    binmat = [];
    for i=1:length(simdata.simstep)
        binmat = [binmat, (simdata.simstep(i).lambda_zmp != 0)];
    end

    spy(binmat);
    axis equal;
end
