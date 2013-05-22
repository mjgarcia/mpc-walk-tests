function rotMat = angToRotMat(ang)

sx = sin(ang(1)); cx = cos(ang(1));
sy = sin(ang(2)); cy = cos(ang(2));
sz = sin(ang(3)); cz = cos(ang(3));

rx = [  1,   0,   0; ... 
        0,   cx, -sx;... 
        0,   sx, cx]; 
    
ry = [  cy,  0,  sy; ... 
         0,  1,  0; ... 
       -sy,  0,  cy]; 
   
rz = [  cz,  -sz,  0; ... 
        sz,  cz,  0; ... 
         0,   0,  1]; 

%rotMat = rz*ry*rx;
rotMat = rx*ry*rz;