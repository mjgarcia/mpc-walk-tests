addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6


enabled_steps_plot = true;


[disturbance, delta_dist] = init_disturbance_05();

apply_disturb_12_walk_01
