function [mpc_state] = shift_mpc_state(mpc, mpc_state, simdata)
    mpc_state.cstate = simdata.cstateProfile(1:mpc.Ns, end);

    if (mpc_state.pwin(mpc_state.counter + 1).support_len == 1)
        mpc_state.p = simdata.simstep(end).plannedSteps(1).p;
    end

    mpc_state.counter = mpc_state.counter + 1;

    if (length(mpc_state.pwin) - mpc_state.counter) < mpc.N;
        mpc_state.stop = 1;
    end
end

