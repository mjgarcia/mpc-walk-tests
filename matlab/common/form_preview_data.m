function [mpc_state] = form_preview_data(robot, mpc_state, walk,indices)
load_constants

% preview data
k = (indices(1)-1)*8+1;
for j = walk.steps(indices(1)).len:-1:1;
    mpc_state.pwin(k).support_type = walk.steps(indices(1)).type;    % type
    mpc_state.pwin(k).support_len = j;                      % the number of remaining iterations in this ss

    if (mpc_state.pwin(k).support_type == LSS)
        if (walk.steps(indices(2)).type == DS)
            mpc_state.pwin(k).f_bounds = robot.right_foot_position_fixed_ss;
        else
            mpc_state.pwin(k).f_bounds = robot.right_foot_position_bounds_ss;
        end
    elseif (mpc_state.pwin(k).support_type == RSS)
        if (walk.steps(indices(2)).type == DS)
            mpc_state.pwin(k).f_bounds = robot.left_foot_position_fixed_ss;
        else
            mpc_state.pwin(k).f_bounds = robot.left_foot_position_bounds_ss;
        end
    else
        if (mpc_state.stopping)
            mpc_state.pwin(k).f_bounds = zeros(2,2);
        else
            if (walk.steps(indices(2)).type == LSS)
                mpc_state.pwin(k).f_bounds = robot.left_foot_position_fixed_ds;
            else
                mpc_state.pwin(k).f_bounds = robot.right_foot_position_fixed_ds;
            end
        end
    end
    k = k + 1;
end