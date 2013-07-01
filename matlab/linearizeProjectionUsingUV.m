function matLinProj = linearizeProjectionUsingUV(lm_proj,z,Nlm)

matLinProj = zeros(2,4,Nlm);
for l = 1:Nlm
    matLinProj(1,1,l) = 1/z(l);
    matLinProj(2,2,l) = matLinProj(1,1,l);
    matLinProj(1,3,l) = -lm_proj(1,l)/z(l);
    matLinProj(2,3,l) = -lm_proj(2,l)/z(l);
    matLinProj(1,4,l) = lm_proj(1,l);
    matLinProj(2,4,l) = lm_proj(2,l);
end