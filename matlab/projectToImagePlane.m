function lm_proj = projectToImagePlane(Olm_cam)

% Projection
Olm_cam(1,:) = Olm_cam(1,:)./Olm_cam(3,:);
Olm_cam(2,:) = Olm_cam(2,:)./Olm_cam(3,:);
lm_proj = Olm_cam(1:2,:);