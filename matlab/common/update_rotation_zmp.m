function [mpc_state] = update_rotation_zmp(mpc, mpc_state, feet_rot)

    Ni = mpc_state.counter;

    for i = 1:mpc.N;
        mpc_state.pwin(Ni+i).R = [
                    cos(feet_rot(i)), -sin(feet_rot(i));
                    sin(feet_rot(i)), cos(feet_rot(i))];
        %mpc_state.pwin(Ni+i).cvel_ref = mpc_state.pwin(Ni+i).R * mpc_state.pwin(Ni+i).cvel_ref;
        %mpc_state.pwin(Ni+i).cvel_ref
    end
end
