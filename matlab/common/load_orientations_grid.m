function grid = load_orientations_grid()

grid.file = 'grid.txt';
orientationsGrid = importdata(grid.file,' ',4);
text = orientationsGrid.textdata;
text = regexp(text,' ','split');

grid.finalInGrid = [str2double(text{1}{2}); str2double(text{1}{3})];
grid.landMarkInGrid = [str2double(text{2}{2}); str2double(text{2}{3})];
grid.width = str2double(text{3}{2});
grid.delta = str2double(text{4}{2});

grid.rotationAngle = atan2(grid.landMarkInGrid(2)-grid.finalInGrid(2),grid.landMarkInGrid(1)-grid.finalInGrid(1));
grid.rotationMatrix = [cos(grid.rotationAngle) -sin(grid.rotationAngle);...
                        sin(grid.rotationAngle) cos(grid.rotationAngle)];
%radtodeg(theta)
 
grid.scale = 0.01; % One unit = 1 cm.
grid.finalInWorld = grid.scale*grid.finalInGrid;

fullWidth = 2*grid.width + 1;
grid.orientations = orientationsGrid.data(:,3);
grid.orientations = reshape(grid.orientations,fullWidth,fullWidth);
grid.orientations = fliplr(grid.orientations);

grid.x = orientationsGrid.data(:,1);
grid.x = reshape(grid.x,fullWidth,fullWidth);
grid.x = fliplr(grid.x);
%xs = reshape(xs,fullWidth*fullWidth,1);

grid.y = orientationsGrid.data(:,2);
grid.y = reshape(grid.y,fullWidth,fullWidth);
grid.y = fliplr(grid.y);
%ys = reshape(ys,fullWidth*fullWidth,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pointInWorld = [-0.5; 1];
% pointInGrid = pointInWorld/grid.scale;
% pointInGrid = grid.rotationMatrix'*(pointInGrid - grid.finalInGrid);
% index = round(pointInGrid/grid.delta);
% index1(1) = grid.width + 1 - index(2);
% index1(2) = grid.width + 1 + index(1);
% 
% index = grid.width + 1 - index;
% indexLin = fullWidth*(index(1)-1) + index(2);
% angle = orientationsGrid.data(indexLin,3);
% 
% plot(grid.scale*orientationsGrid.data(:,1),grid.scale*orientationsGrid.data(:,2),'.');
% hold('on');
% %plot(grid.scale*xs(1),grid.scale*ys(1),'.m');
% %plot(grid.scale*xs(fullWidth),grid.scale*ys(fullWidth),'.m');
% %plot(grid.scale*xs(fullWidth+1),grid.scale*ys(fullWidth+1),'.m');
% plot(grid.scale*grid.landMarkInGrid(1),grid.scale*grid.landMarkInGrid(2),'*r');
% plot(grid.scale*grid.finalInGrid(1),grid.scale*grid.finalInGrid(2),'*g');
% plot(pointInWorld(1),pointInWorld(2),'*c');
% plot(grid.scale*orientationsGrid.data(indexLin,1),grid.scale*orientationsGrid.data(indexLin,2),'*m');
% plot(grid.scale*xs(index1(1),index1(2)),grid.scale*ys(index1(1),index1(2)),'om')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dir_df_dx dir_df_dy] = gradient(grid.orientations,grid.delta*grid.scale,grid.delta*grid.scale);

x_direction = [cos(grid.rotationAngle); -sin(grid.rotationAngle)];
y_direction = [sin(grid.rotationAngle); cos(grid.rotationAngle)];

grid.df_dx = dir_df_dx*x_direction(1) + dir_df_dy*x_direction(2);
grid.df_dy = dir_df_dx*y_direction(1) + dir_df_dy*y_direction(2);

% quiver(grid.scale*xs,grid.scale*ys,grid.df_dx,grid.df_dy);
% figure;
% quiver(grid.scale*xs,grid.scale*ys,dir_df_dx,dir_df_dy);
%quiver(grid.scale*xs,grid.scale*ys,cos(grid.orientations),sin(grid.orientations));
