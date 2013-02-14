addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6_18


enabled_steps_plot = false;


[disturbance, delta_dist] = init_disturbance_03();

apply_disturb_12_walk_01
