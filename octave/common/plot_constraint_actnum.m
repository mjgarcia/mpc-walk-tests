function plot_constraint_actnum(simdata)
    load_constants
    load_plotting_options

    X = [];
    for i=1:length(simdata.simstep)
        X = [X, sum(simdata.simstep(i).lambda_zmp != 0)];
    end

    plot (X);
end
