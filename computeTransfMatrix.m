function [T] = computeTransfMatrix(state)
rotMat = angToRotMat(state(4:6));
T = [[rotMat state(1:3)]; [zeros(1,3) 1]];
    
