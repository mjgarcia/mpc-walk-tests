function [simdata] = init_simdata(mpc, mpc_state)
    simdata.cstateProfile = repmat(mpc_state.cstate, mpc.N, 1);

    % assuming that acceleration = 0
    simdata.zmpProfile = repmat([mpc_state.cstate(1); mpc_state.cstate(4)], mpc.N, 1);

    simdata.cpProfile = [];

    simdata.execTime = [];

    simdata.fixedSteps(1).p = mpc_state.p;
    simdata.fixedSteps(1).R = mpc_state.pwin(1).R;
    simdata.fixedSteps(1).support_type = mpc_state.pwin(1).support_type;
end
