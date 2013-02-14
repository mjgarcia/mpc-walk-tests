function [dist, delta_dist, disturb_iter] = init_disturbance_03()
    dist = [0.0;
            0.0;
            0.0;
            0.0;
            0.08;
            0.0];

    delta_dist = [0.0;
                  0.0;
                  0.0;
                  0.0;
                  0.01;
                  0.0];

    disturb_iter = 16;
end
