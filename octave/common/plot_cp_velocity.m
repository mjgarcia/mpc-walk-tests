function plot_cp_velocity(simdata)
    figure
    hold on
    plot(simdata.cpvProfile(1,:), 'x-')
    plot(simdata.cpvProfile(end-1,:), 'ro-')
    hold off

    figure
    hold on
    plot(simdata.cpvProfile(2,:), 'x-')
    plot(simdata.cpvProfile(end,:), 'ro-')
    hold off
end
