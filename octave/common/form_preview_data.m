function [mpc_state] = form_preview_data(robot, mpc_state, mpc, walk)
    load_constants

    % preview data
    k = 1;
    for i = 1:length(walk.steps);
        for j = walk.steps(i).len:-1:1;
            mpc_state.pwin(k).cvel_ref = walk.steps(i).cvel_ref;        % velocity vector

            mpc_state.pwin(k).T = mpc.T;                    % duration of the iteration;
            mpc_state.pwin(k).hg = robot.h/9.8;             % Height of the CoM / gravitational acceleration
            mpc_state.pwin(k).omega = sqrt(mpc_state.pwin(k).hg);

            mpc_state.pwin(k).R = [
                    cos(walk.steps(i).theta), -sin(walk.steps(i).theta);
                    sin(walk.steps(i).theta), cos(walk.steps(i).theta)];
            mpc_state.pwin(k).cvel_ref = mpc_state.pwin(k).R * mpc_state.pwin(k).cvel_ref;
            
            mpc_state.pwin(k).support_type = walk.steps(i).type;    % type
            mpc_state.pwin(k).support_len = j;                      % the number of remaining iterations in this ss

            if (mpc_state.pwin(k).support_type == LSS)
                if (i+1 <= length(walk.steps)) && (walk.steps(i+1).type == DS)
                    mpc_state.pwin(k).f_bounds = robot.right_foot_position_fixed_ss;
                else
                    mpc_state.pwin(k).f_bounds = robot.right_foot_position_bounds_ss;
                end
            elseif (mpc_state.pwin(k).support_type == RSS)
                if (i+1 <= length(walk.steps)) && (walk.steps(i+1).type == DS)
                    mpc_state.pwin(k).f_bounds = robot.left_foot_position_fixed_ss;
                else
                    mpc_state.pwin(k).f_bounds = robot.left_foot_position_bounds_ss;
                end
            else
                if (i == length(walk.steps))
                    mpc_state.pwin(k).f_bounds = zeros(2,2);
                else
                    if (walk.steps(i+1).type == LSS)
                        mpc_state.pwin(k).f_bounds = robot.left_foot_position_fixed_ds;
                    else
                        mpc_state.pwin(k).f_bounds = robot.right_foot_position_fixed_ds;
                    end
                end
            end

            k = k + 1;
        end
    end
end
