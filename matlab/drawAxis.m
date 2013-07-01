function [] = drawAxis(transfMat,drawText)

rotMat = transfMat(1:3,1:3);
origin = transfMat(1:3,4);

unitX = [1; 0; 0];
unitY = [0; 1; 0];
unitZ = [0; 0; 1];

length = 0.2;

axisX = length*rotMat*unitX;
axisY = length*rotMat*unitY;
axisZ = length*rotMat*unitZ;

endX = origin+axisX;
endY = origin+axisY;
endZ = origin+axisZ;

pointsX = [origin(1) endX(1) origin(1) endY(1) origin(1) endZ(1)];
pointsY = [origin(2) endX(2) origin(2) endY(2) origin(2) endZ(2)];
pointsZ = [origin(3) endX(3) origin(3) endY(3) origin(3) endZ(3)];

plot3(origin(1),origin(2),origin(3),'.');
if drawText == true
    plot3(pointsX,pointsY,pointsZ);
    text([endX(1) endY(1) endZ(1)], [endX(2) endY(2) endZ(2)],...
        [endX(3) endY(3) endZ(3)], ['x';'y';'z'],'FontSize',12);
end

