function mpc_state = update_walk(mpc_state, callStop, walk,indices)

if mod(mpc_state.counter-1,8) ~= 0 || mpc_state.stopping
    return
end

if(callStop)
    walk.steps(walk.indices(3)).type = DS;
    walk.steps(walk.indices(3)).len = mpc.N;
    mpc_state.stopping = 1;
else
    if walk.steps(walk.indices(2)).type == RSS
        walk.steps(walk.indices(3)).type = LSS;
    else
        walk.steps(walk.indices(3)).type = RSS;
    end
    walk.steps(walk.indices(3)).len = walk.ss_len;
end

mpc_state = form_preview_data(robot, mpc_state, walk, indices);
walk.indices = circshift(walk.indices,[0 -1]);
