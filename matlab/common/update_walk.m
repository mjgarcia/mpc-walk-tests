function mpc_state = update_walk(state_counter, stop, walk)

if(stop)
    walk.steps.type = DS;
    walk.steps.len = mpc.N;
    walk.steps.theta = walk.steps.prev_theta;
    mpc_state.stop = 1;
    return;
end

switch state_counter
    case 1
        % Support type
        walk.steps.type = DS;
        % Duration (iterations)
        walk.steps.len = 1;
        % Orientation of the support (angle, global)
        walk.steps.theta = initPos(3);
    case 2
        walk.steps.type = RSS;
        walk.steps.len = walk.ss_len;
        walk.steps.theta = initPos(3);
    otherwise
        if walk.steps.prev_type == RSS
            walk.steps.type = LSS;
        else
            walk.steps.type = RSS;
        end
        walk.steps.len = walk.ss_len;
        %walk.steps.theta = 0;
end

mpc_state = form_preview_data(robot, mpc_state, mpc, walk);