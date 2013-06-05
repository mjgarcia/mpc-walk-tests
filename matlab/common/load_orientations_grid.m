function grid = load_orientations_grid()

grid.file = 'grid10.txt';
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
grid.orientations = circshift(grid.orientations,[1 0]);
grid.orientations = wrapToPi(grid.orientations);

grid.x = orientationsGrid.data(:,1);
grid.x = reshape(grid.x,fullWidth,fullWidth);
grid.x = fliplr(grid.x);
%grid.x = circshift(grid.x,[1 0]);

grid.y = orientationsGrid.data(:,2);
grid.y = reshape(grid.y,fullWidth,fullWidth);
grid.y = fliplr(grid.y);
%grid.y = circshift(grid.y,[1 0]);

grid.partition = orientationsGrid.data(:,4);
grid.partition = reshape(grid.partition,fullWidth,fullWidth);
grid.partition = fliplr(grid.partition);
grid.partition= circshift(grid.partition,[1 0]);

grid.nhWeight = orientationsGrid.data(:,4);
grid.nhWeight = reshape(grid.nhWeight,fullWidth,fullWidth);
grid.nhWeight = fliplr(grid.nhWeight);
grid.nhWeight(grid.nhWeight < 0 ) = 0;

orthogonal = grid.orientations + pi/2;
slopes = tan(orthogonal);
xx = grid.scale*grid.x;
yy = grid.scale*grid.y;
b = yy - slopes.*xx;

grid.forward_backward = sign(grid.orientations).*(grid.finalInWorld(2) - slopes.*grid.finalInWorld(1) -b) > 0;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %pointInWorld = [-0.5; 1];
% pointInWorld = [-4; 3];
% pointInGrid = pointInWorld/grid.scale;
% pointInGrid = grid.rotationMatrix'*(pointInGrid - grid.finalInGrid);
% index = round(pointInGrid/grid.delta);
% index1(1) = grid.width + 1 - index(2);
% index1(2) = grid.width + 1 + index(1);
% 
% index = grid.width + 1 - index;
% indexLin = fullWidth*(index(1)-1) + index(2);
% 
% % plot(grid.scale*orientationsGrid.data(:,1),grid.scale*orientationsGrid.data(:,2),'.');
% % plot(grid.scale*xs(1),grid.scale*ys(1),'.m');
% % plot(grid.scale*xs(fullWidth),grid.scale*ys(fullWidth),'.m');
% % plot(grid.scale*xs(fullWidth+1),grid.scale*ys(fullWidth+1),'.m');
% plot(grid.scale*grid.landMarkInGrid(1),grid.scale*grid.landMarkInGrid(2),'*r');
% hold('on');
% axis('equal');
% quiver(grid.scale*grid.x,grid.scale*grid.y,cos(grid.orientations),sin(grid.orientations));
% plot(grid.scale*grid.finalInGrid(1),grid.scale*grid.finalInGrid(2),'*g');
% plot(pointInWorld(1),pointInWorld(2),'*c');
% plot(grid.scale*orientationsGrid.data(indexLin,1),grid.scale*orientationsGrid.data(indexLin,2),'*m');
% plot(grid.scale*grid.x(index1(1),index1(2)),grid.scale*grid.y(index1(1),index1(2)),'om')
% 
% % angle = grid.orientations(index1(1),index1(2));
% % if(angle < 0)
% % m = tan(angle+pi/2);
% % else
% % m = tan(angle-pi/2);    
% % end
% % xx = grid.scale*grid.x(index1(1),index1(2));
% % yy = grid.scale*grid.y(index1(1),index1(2));
% % b = yy - m*xx;
% % %hline = refline(m,b);
% % x = xx-1:0.1:xx+1;
% % y = m*x+b;
% % plot(x,y,'r');
% % pointTest = [-4 3.1];
% % plot(pointTest(1),pointTest(2),'r*');
% % pointTest(2) - m*pointTest(1) - b > 0
% 
% % orthogonal = grid.orientations + pi/2;
% % positives = grid.orientations > 0;
% % orthogonal(positives) = grid.orientations(positives) - pi/2;
% % orthogonal(~positives) = grid.orientations(~positives) - pi/2;
% 
% %pointTest = [-4 3.1];
% pointTest = grid.finalInWorld;
% %indexTest = [10,10];
% indexTest = [70,70];
% plot(pointTest(1),pointTest(2),'r*');
% plot(xx(indexTest(1),indexTest(2)),yy(indexTest(1),indexTest(2)),'r*');
% sign(grid.orientations(indexTest(1),indexTest(2)))*(pointTest(2) - slopes(indexTest(1),indexTest(2))*pointTest(1) - b(indexTest(1),indexTest(2))) > 0
% radtodeg(grid.orientations(indexTest(1),indexTest(2)))
% radtodeg(orthogonal(indexTest(1),indexTest(2)))
% slopes(indexTest(1),indexTest(2))
% 
% x = xx(indexTest(1),indexTest(2))-1:0.1:xx(indexTest(1),indexTest(2))+1;
% y = slopes(indexTest(1),indexTest(2))*x+b(indexTest(1),indexTest(2));
% plot(x,y,'r');
% 
% plot(grid.forward_backward.*xx,grid.forward_backward.*yy,'r*');
% plot(grid.nhWeight.*xx,grid.nhWeight.*yy,'r*');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dir_df_dx dir_df_dy] = gradient(grid.orientations,grid.delta*grid.scale,grid.delta*grid.scale);

x_direction = [cos(grid.rotationAngle); -sin(grid.rotationAngle)];
y_direction = [sin(grid.rotationAngle); cos(grid.rotationAngle)];

grid.df_dx = dir_df_dx*x_direction(1) + dir_df_dy*x_direction(2);
grid.df_dy = dir_df_dx*y_direction(1) + dir_df_dy*y_direction(2);

% quiver(grid.scale*xs,grid.scale*ys,grid.df_dx,grid.df_dy);
% figure;
% quiver(grid.scale*xs,grid.scale*ys,dir_df_dx,dir_df_dy);
