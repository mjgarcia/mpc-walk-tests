function plot_partition_grid(grid)
    hold('on');

    rate = 1;
    x = grid.x(1:rate:end,:);
    x = x(:,1:rate:end);

    y = grid.y(1:rate:end,:);
    y = y(:,1:rate:end);

    orientations = grid.orientations(1:rate:end,:);
    orientations = orientations(:,1:rate:end);

    partition = grid.partition(1:rate:end,:);
    partition = partition(:,1:rate:end);

    indices = partition == 1;
    quiver(grid.scale*x(indices),grid.scale*y(indices),cos(orientations(indices)),sin(orientations(indices)),'color', [200 255 200]/255);

    indices = partition == 2 | partition == 3 | partition == 4 | partition == 5;
    quiver(grid.scale*x(indices),grid.scale*y(indices),cos(orientations(indices)),sin(orientations(indices)),'color', [220 220 255]/255);

    indices = partition == 6 | partition == 7;
    quiver(grid.scale*x(indices),grid.scale*y(indices),cos(orientations(indices)),sin(orientations(indices)),'color', [200 255 255]/255);

    indices = partition == 8 | partition == 9;
    quiver(grid.scale*x(indices),grid.scale*y(indices),cos(orientations(indices)),sin(orientations(indices)),'color', [255 220 200]/255);

    indices = partition == 10 | partition == 11;
    quiver(grid.scale*x(indices),grid.scale*y(indices),cos(orientations(indices)),sin(orientations(indices)),'color', [255 255 200]/255);

    indices = partition == 12 | partition == 13;
    quiver(grid.scale*x(indices),grid.scale*y(indices),cos(orientations(indices)),sin(orientations(indices)),'color', [250 230 220]/255);

end
