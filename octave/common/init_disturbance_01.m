function [dist, delta_dist, disturb_iter] = init_disturbance_01()
    dist = [0.0;
            0.0;
            0.0;
            0.0;
            -0.07804;
            0.0];

    delta_dist = [0.0;
                  0.0;
                  0.0;
                  0.0;
                  -0.000005;
                  0.0];

    disturb_iter = 16;
end
