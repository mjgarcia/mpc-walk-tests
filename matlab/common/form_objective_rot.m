function [H_rot, q_rot] = form_objective_rot (mpc_rot, S0v_rot, Uv, weightsMatrix, D1, D2, L, twistMatrix_cm_cam, errors, Nlm)

    %D1Sqr = D1'*D1;
    %D2Sqr = D2'*D2;

    %H_rot = mpc_rot.alpha*Uv'*D1Sqr*Uv + mpc_rot.gamma*Up'*D3Sqr*Up;
    %q_rot = mpc_rot.alpha*Uv'*D1'*(D1*S0v_rot - mpc_state_rot.ref_vel) + mpc_rot.gamma*Up'*D3Sqr*S0p_rot;

    %H_rot = mpc_rot.alpha*Up'*D1Sqr*Up + mpc_rot.gamma*Up'*D3Sqr*Up;
    %q_rot = mpc_rot.alpha*Up'*D1'*(D1*S0p_rot - mpc_state_rot.ref_pos) + mpc_rot.gamma*Up'*D3Sqr*S0p_rot;

    %     Up = Up(1:2:end,:);
    %     Up = Up(:,1:2:end);
    %     S0p_rot = S0p_rot(1:2:end);
    %     H_rot = Up'*Up;
    %     q_rot = Up'*(S0p_rot - mpc_state_rot.ref);

    NuN = mpc_rot.N*mpc_rot.Nu;

    sumH = zeros(NuN, NuN);
    sumq = zeros(NuN,1);

    tmp1 = (mpc_rot.T*L(1,:)*twistMatrix_cm_cam(:,6))^2;
    tmp2 = (mpc_rot.T*L(2,:)*twistMatrix_cm_cam(:,6))^2;

    for l=1:Nlm
        sumH = sumH +  tmp1*Uv'*D1'*weightsMatrix*D1*Uv + tmp2*Uv'*D1'*weightsMatrix*D1*Uv + ...
                       tmp1*Uv'*D2'*weightsMatrix*D2*Uv + tmp2*Uv'*D2'*weightsMatrix*D2*Uv;

        sumq = sumq + tmp1*Uv'*D1'*weightsMatrix*(D1*S0v_rot + errors(1,l)*ones(mpc_rot.N,1)) + tmp2*Uv'*D1'*weightsMatrix*(D1*S0v_rot + errors(2,l)*ones(mpc_rot.N,1)) + ...
                      tmp1*Uv'*D2'*weightsMatrix*(D2*S0v_rot + errors(1,l)*ones(mpc_rot.N,1)) + tmp2*Uv'*D2'*weightsMatrix*(D2*S0v_rot + errors(2,l)*ones(mpc_rot.N,1));
    end

    H_rot =  mpc_rot.beta * eye(NuN) + mpc_rot.alpha * sumH;
    q_rot = mpc_rot.alpha * sumq;

end
