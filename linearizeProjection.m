function matLinProj = linearizeProjection(Olm_cam)

matLinProj = zeros(2,4);
m = mean(Olm_cam(1:3,:),2);
matLinProj(1,1) = 1/m(3);
matLinProj(2,2) = matLinProj(1,1);
matLinProj(1,3) = -m(1)/(m(3)*m(3));
matLinProj(2,3) = -m(2)/(m(3)*m(3));
matLinProj(1,4) = m(1)/m(3);
matLinProj(2,4) = m(2)/m(3);