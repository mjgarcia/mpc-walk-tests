function [AB0xy Vel0] = form_planner_matrices(planner,mpc,tangent_optimal,dtan_dx,dtan_dy,p0)

sine = sin(tangent_optimal);
cosine = cos(tangent_optimal);
a0x = planner.vel*sine*dtan_dx;
b0x = planner.vel*sine*dtan_dy;
a0y = planner.vel*cosine*dtan_dx;
b0y = planner.vel*cosine*dtan_dx;

vel0x = planner.vel*(-cosine + sine*(-dtan_dx*p0(1) - dtan_dy*p0(2)));
vel0y = planner.vel*(-sine + cosine*(-dtan_dx*p0(1) - dtan_dy*p0(2)));

blk = [a0x b0x; a0y b0y];
rep = repmat(blk,[1,1,mpc.N]);
tmp = num2cell(rep,[1 2]);
AB0xy = blkdiag(tmp{:});

Vel0 = repmat([vel0x; vel0y],mpc.N,1);