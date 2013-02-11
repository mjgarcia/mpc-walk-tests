function plot_com_zmp_current(mpc_state)
    com_position = mpc_state.cstate([1,4]);
    zmp_position = mpc_state.cstate([1,4]) - mpc_state.pwin(mpc_state.counter + 1).hg * mpc_state.cstate([3,6]);
    cp_position = mpc_state.cstate([1,4]) + mpc_state.cstate([2,5]) / mpc_state.pwin(mpc_state.counter + 1).omega;
    plot (zmp_position(1), zmp_position(2), 'oc', 'linewidth', 3);
    plot (com_position(1), com_position(2), 'ob', 'linewidth', 3);
    plot (cp_position(1), cp_position(2), 'kd', 'linewidth', 3);
end
