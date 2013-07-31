function [mpc_state] = update_rotation_zmp(mpc, mpc_state, theta_com, vcom)

    Ni = mpc_state.counter;

    for i = 1:mpc.N;
        mpc_state.pwin(Ni+i).R = [
                    cos(theta_com), -sin(theta_com);
                    sin(theta_com), cos(theta_com)];
        mpc_state.pwin(Ni+i).cvel_ref = mpc_state.pwin(Ni+i).R *vcom;
    end
end
