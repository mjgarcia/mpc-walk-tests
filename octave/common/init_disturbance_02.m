function [dist, delta_dist, disturb_iter] = init_disturbance_02()
    dist = [0.0;
            0.0;
            0.0;
            0.0;
            0.06;
            0.0];

    delta_dist = [0.0;
                  0.0;
                  0.0;
                  0.0;
                  0.005;
                  0.0];

    disturb_iter = 6;
end
