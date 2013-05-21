function [AB0xy Vel0] = form_planner_matrices(planner,mpc,angle_optimal,dangle,p0)

sine = sin(angle_optimal);
cosine = cos(angle_optimal);
a0x = planner.vel*sine*dangle(1);
b0x = planner.vel*sine*dangle(2);
a0y = planner.vel*cosine*dangle(1);
b0y = planner.vel*cosine*dangle(2);

vel0x = planner.vel*(-cosine + sine*(-dangle(1)*p0(1) - dangle(2)*p0(2)));
vel0y = planner.vel*(-sine + cosine*(-dangle(1)*p0(1) - dangle(2)*p0(2)));

blk = [a0x b0x; a0y b0y];
rep = repmat(blk,[1,1,mpc.N]);
tmp = num2cell(rep,[1 2]);
AB0xy = blkdiag(tmp{:});

Vel0 = repmat([vel0x; vel0y],mpc.N,1);