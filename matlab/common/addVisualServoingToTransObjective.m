function [H, q] = addVisualServoingToTransObjective(H, q, mpc, S0, Uv,...
                                                    weightsMatrix, D1, D2, ...
                                                    L, twistMatrix_cm_cam, ...
                                                    w, errors,Nlm,delta)

NuN = mpc.N*mpc.Nu;

sumH = zeros(NuN, NuN);
sumq = zeros(NuN,1);

trig = tril(ones(mpc.N,mpc.N)); 
crec = trig * ones(mpc.N,1);
fact = 0.1;

for l=1:Nlm
    tmp1x =  fact*mpc.T*L(2*l-1,:)*(twistMatrix_cm_cam(:,1));
    tmp1y =  fact*mpc.T*L(2*l-1,:)*(twistMatrix_cm_cam(:,2));

    tmp2x =  mpc.T*L(2*l,:)*(twistMatrix_cm_cam(:,1));
    tmp2y =  mpc.T*L(2*l,:)*(twistMatrix_cm_cam(:,2));

    tmp1w= (mpc.T*L(2*l-1,:)*twistMatrix_cm_cam(:,6)*w);
    tmp2w= (mpc.T*L(2*l  ,:)*twistMatrix_cm_cam(:,6)*w);

    %% SUM ALL QUADRATIC TERMS
        sumH = sumH +  ...
               fact*tmp1x*tmp1x*Uv'*D1'*trig'*weightsMatrix*trig*D1*Uv + ...
               fact*tmp1y*tmp1y*Uv'*D2'*trig'*weightsMatrix*trig*D2*Uv + ...
               tmp2x*tmp2x*Uv'*D1'*trig'*weightsMatrix*trig*D1*Uv + ...
               tmp2y*tmp2y*Uv'*D2'*trig'*weightsMatrix*trig*D2*Uv;        

        sumq = sumq + ...
               fact*tmp1x*Uv'*D1'*trig'*weightsMatrix*(tmp1x*trig*D1*S0-tmp1w*crec+ errors(1,l)*ones(mpc.N,1))+ ...
               fact*tmp1y*Uv'*D2'*trig'*weightsMatrix*(tmp1y*trig*D2*S0-tmp1w*crec+ errors(1,l)*ones(mpc.N,1))+ ...
               tmp2x*Uv'*D1'*trig'*weightsMatrix*(tmp2x*trig*D1*S0-tmp2w*crec+ errors(2,l)*ones(mpc.N,1))+ ...
               tmp2y*Uv'*D2'*trig'*weightsMatrix*(tmp2y*trig*D2*S0-tmp2w*crec+ errors(2,l)*ones(mpc.N,1));
    end

H(1:NuN, 1:NuN) = H(1:NuN, 1:NuN) + delta*sumH;

q(1:NuN) = q(1:NuN) + delta*sumq;