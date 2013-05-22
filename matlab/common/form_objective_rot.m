function [H_rot, q_rot, S0p_rot, Up] = form_objective_rot (mpc_rot, mpc_state_rot, S0p_rot, Up, S0v_rot, Uv, D1, D2)

    D1Sqr = D1'*D1;
    D2Sqr = D2'*D2;

    %H_rot = mpc_rot.alpha*Uv'*D1Sqr*Uv + mpc_rot.gamma*Up'*D3Sqr*Up;
    %q_rot = mpc_rot.alpha*Uv'*D1'*(D1*S0v_rot - mpc_state_rot.ref_vel) + mpc_rot.gamma*Up'*D3Sqr*S0p_rot;
    
    %H_rot = mpc_rot.alpha*Up'*D1Sqr*Up + mpc_rot.gamma*Up'*D3Sqr*Up;
    %q_rot = mpc_rot.alpha*Up'*D1'*(D1*S0p_rot - mpc_state_rot.ref_pos) + mpc_rot.gamma*Up'*D3Sqr*S0p_rot;

    H_rot = mpc_rot.beta*eye(mpc_rot.N*mpc_rot.Nu) + mpc_rot.alpha*Up'*D1Sqr*Up + mpc_rot.alpha*Up'*D2Sqr*Up;
    q_rot = mpc_rot.alpha*Up'*D1'*(D1*S0p_rot - mpc_state_rot.ref_pos) + mpc_rot.alpha*Up'*D2'*(D2*S0p_rot - mpc_state_rot.ref_pos);

%     Up = Up(1:2:end,:);
%     Up = Up(:,1:2:end);
%     S0p_rot = S0p_rot(1:2:end);
%     H_rot = Up'*Up;
%     q_rot = Up'*(S0p_rot - mpc_state_rot.ref);

end
