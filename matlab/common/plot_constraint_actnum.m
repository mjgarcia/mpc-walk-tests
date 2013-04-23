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
    plot (X, 'b');
    plot (X_act, 'r');
    plot (X_deact, 'k');
    hold off
%    X = [];
%    for i=1:length(simdata.simstep)
%        X = [X, sum(simdata.simstep(i).lambda_zmp != 0)];
%    end
%
%    plot (X);
end
