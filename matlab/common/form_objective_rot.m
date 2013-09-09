function [H_rot, q_rot] = form_objective_rot (mpc_rot, S0v_rot, Uv, ...
                                              weightsMatrix, D1, D2, ...
                                              L, twistMatrix_cm_cam, ...
                                              vx,vy,errors, Nlm)

    NuN = mpc_rot.N*mpc_rot.Nu;

    sumH = zeros(NuN, NuN);
    sumq = zeros(NuN,1);

    trig = tril(ones(mpc_rot.N,mpc_rot.N)); 
    crec = trig * ones(mpc_rot.N,1);
    
    fact = 0.1;

    for l=1:Nlm

        tmp1 = (mpc_rot.T*L(2*l-1,:)*twistMatrix_cm_cam(:,6));
        tmp2 = (mpc_rot.T*L(2*l  ,:)*twistMatrix_cm_cam(:,6));

        tmp1v=  mpc_rot.T*L(2*l-1,:)*(twistMatrix_cm_cam(:,1)*vx+twistMatrix_cm_cam(:,2)*vy);
        tmp2v=  mpc_rot.T*L(2*l  ,:)*(twistMatrix_cm_cam(:,1)*vx+twistMatrix_cm_cam(:,2)*vy);

        %% SUM ALL QUADRATIC TERMS
        sumH = sumH +  ...
               tmp1*tmp1*Uv'*D1'*trig'*weightsMatrix*trig*D1*Uv + ...
               tmp2*tmp2*Uv'*D1'*trig'*weightsMatrix*trig*D1*Uv;        

        sumq = sumq + ...
               tmp1*Uv'*D1'*trig'*weightsMatrix*(tmp1*trig*D1*S0v_rot- tmp1v*crec+ errors(1,l)*ones(mpc_rot.N,1)) + ...
               tmp2*Uv'*D1'*trig'*weightsMatrix*(tmp2*trig*D1*S0v_rot- tmp2v*crec+ errors(2,l)*ones(mpc_rot.N,1));
    end

    H_rot =  mpc_rot.beta * eye(NuN) + mpc_rot.alpha * sumH;
    q_rot = mpc_rot.alpha * sumq;

end
