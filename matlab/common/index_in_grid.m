function [index] = index_in_grid(grid,pointInWorld)

pointInGrid = pointInWorld/grid.scale;
pointInGrid = grid.rotationMatrix'*(pointInGrid - grid.finalInGrid);
index1 = round(pointInGrid/grid.delta);
index(1) = grid.width + 1 - index1(2);
index(2) = grid.width + 1 + index1(1);
