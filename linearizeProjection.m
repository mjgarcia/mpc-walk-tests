function matLinProj = linearizeProjection(Olm_cam,Nlm)

matLinProj = zeros(2,4,Nlm);
for l = 1:Nlm
    matLinProj(1,1,l) = 1/Olm_cam(3,l);
    matLinProj(2,2,l) = matLinProj(1,1,l);
    matLinProj(1,3,l) = -Olm_cam(1,l)/(Olm_cam(3,l)*Olm_cam(3,l));
    matLinProj(2,3,l) = -Olm_cam(2,l)/(Olm_cam(3,l)*Olm_cam(3,l));
    matLinProj(1,4,l) = Olm_cam(1,l)/Olm_cam(3,l);
    matLinProj(2,4,l) = Olm_cam(2,l)/Olm_cam(3,l);
end