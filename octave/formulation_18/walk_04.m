addpath(strcat(pwd,'/../common/'))

parameters_robot
parameters_mpc6_18

enabled_steps_plot = true;
flag_first_run = true;
stop_iter = -1;
disturb_iter = -1;

init_walk_04

simulation_loop
