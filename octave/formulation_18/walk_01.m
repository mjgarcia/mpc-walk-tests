addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6_18

enabled_steps_plot = true;
stop_iter = -1;
disturb_iter = -1;
flag_first_run = true;

init_walk_01

simulation_loop
