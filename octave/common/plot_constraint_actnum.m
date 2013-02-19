function plot_constraint_actnum(simdata)
    load_constants
    load_plotting_options


    binmat = [];
    for i=1:length(simdata.simstep)
        binmat = [binmat, (simdata.simstep(i).lambda_zmp != 0)];
    end

    X = sum (binmat);

    binmat_diff = binmat - [binmat(:,1), binmat(:,1:end-1)];

    X_act = sum (binmat_diff == 1);
    X_deact = - sum (binmat_diff == -1);

    hold on
    plot (X, 'bo-');
    plot (X_act, 'ro-');
    plot (X_deact, 'ko-');
    hold off

    xlabel('iteration of simulation');
    ylabel('number of constraints');

    grid on;
end
