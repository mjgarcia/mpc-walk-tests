addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6

QP_fail_iter = [];
max_state_val = [];
disturbance = [0.0; 
               0.0;
               0.0;
               0.013;
               0.0;
               0.0];
disturbance0 = [0.0; 
                0.0;
                0.0;
                0.0005;
                0.0;
                0.0];
disturb_iter = 6;

cpProfile = [];
disturbProfile = [];

for disturb_counter = 1:15
    disturbance = disturbance + disturbance0;
    disturbProfile = [disturbProfile, max(disturbance)];


    init_walk_01
    simulation_loop
    max_state_val = [max_state_val, max(abs(mpc_state.cstate))];

    if (INFO.info == 0)
        cpProfile = [cpProfile, norm(simdata.cpProfile(:,end) - simdata.zmpProfile(end-1:end, end))];
    end
end

QP_fail_iter
max_state_val

