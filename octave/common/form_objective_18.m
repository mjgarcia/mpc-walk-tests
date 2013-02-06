function [H, q] = form_objective_18 (mpc, Nfp)
    H = blkdiag(zeros (mpc.Nu * mpc.N  +  Nfp), eye(mpc.Nw));
%    H = H + eps * eye(size(H));
    q = zeros (mpc.Nu * mpc.N  +  Nfp  +  mpc.Nw, 1);
end

