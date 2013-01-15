function [simdata] = update_simdata(mpc, mpc_state, S0, U, S0z, Uz, Nfp, X, lambda, lambda_mask, exec_time, simdata)
% V0c, V
%
%

% time
    simdata.execTime = [simdata.execTime, exec_time];


% CoM
    cJerk = X(1:mpc.N*mpc.Nu);

    cState = S0 + U*cJerk;
    simdata.cstateProfile = [simdata.cstateProfile, cState];

% ZMP
    ZMP = S0z + Uz*cJerk;
    simdata.zmpProfile = [simdata.zmpProfile, ZMP];

% capture point
    Ni = mpc_state.counter + mpc.N;
    omega = mpc_state.pwin(Ni).omega;

    ind = (mpc.N-1)*mpc.Ns + 1 : mpc.N*mpc.Ns;
    cstate_N = cState (ind, :);

    simdata.cpProfile = [simdata.cpProfile, (cstate_N([1,4]) + omega * cstate_N([2,5]))];


% planned steps
    if (Nfp > 0)
        F = X(mpc.N*mpc.Nu+1:end);
        %P = V0c + V*F;


        Ni = mpc_state.counter;
        Ni = Ni + mpc_state.pwin(Ni + 1).support_len;
        simstep.plannedSteps(1).p = mpc_state.p + F(1:mpc.Nz);
        simstep.plannedSteps(1).R = mpc_state.pwin(Ni + 1).R;
        simstep.plannedSteps(1).support_type = mpc_state.pwin(Ni + 1).support_type;
        for i = 2:Nfp/mpc.Nz;
            ind = (i-1)*mpc.Nz+1 : (i-1)*mpc.Nz+mpc.Nz;
            Ni = Ni + mpc_state.pwin(Ni + 1).support_len;

            simstep.plannedSteps(i).p = simstep.plannedSteps(i-1).p + F(ind);
            simstep.plannedSteps(i).R = mpc_state.pwin(Ni + 1).R;
            simstep.plannedSteps(i).support_type = mpc_state.pwin(Ni + 1).support_type;
        end
    else
        simstep.plannedSteps = [];
    end

% lambda
    load_constants;
    simstep.lambda_zmp = lambda(find(lambda_mask == CONSTR_ZMP));

    simdata.simstep(mpc_state.counter + 1) = simstep;

% fixed steps
    if (mpc_state.counter > 0)
        Ni = mpc_state.counter;
        if (mpc_state.pwin(Ni).support_len == 1)
            simdata.fixedSteps(end+1).p = mpc_state.p;
            simdata.fixedSteps(end).R = mpc_state.pwin(Ni + 1).R;
            simdata.fixedSteps(end).support_type = mpc_state.pwin(Ni + 1).support_type;
        end
    end
end
