addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6


enabled_steps_plot = false;


[disturbance, delta_dist] = init_disturbance_02();

%stop_after_iter = 30;
%disturb_iter = 10;

apply_disturb_12_walk_01
