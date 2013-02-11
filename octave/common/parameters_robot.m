%%
% Robot
%%%
clear robot;

% Constraints on feet positions
%%%
robot.max_step_len = 0.4;       % Maximal distance between centers of the feet along the sagittal plane (meter)
robot.min_feet_dist = 0.10;     % Maximal distance between centers of the feet along the coronal plane (meter)
robot.max_feet_dist = 0.15;     % Maximal distance between centers of the feet along the coronal plane (meter)
robot.feet_dist_default = 0.10; % The default distance between the feet in initial / final double supports (meter)

% Other
robot.h = 0.26;             % Height of the CoM
robot.foot_len = 0.1;       % Length of a foot (meter)
robot.foot_width = 0.06;    % Width of a foot (meter)



% All following things should work without editing

%%%
robot.ss_zmp_bounds = [
    -robot.foot_len/2,      robot.foot_len/2;
    -robot.foot_width/2,    robot.foot_width/2];

robot.ds_zmp_bounds = [
    -robot.foot_len/2,      robot.foot_len/2;
    -(robot.foot_width + robot.feet_dist_default)/2,    (robot.foot_width + robot.feet_dist_default)/2];


%%% 
% With respect to the center of preceding SS
robot.left_foot_position_bounds_ss = [
    -robot.max_step_len,    robot.max_step_len;
    robot.min_feet_dist,    robot.max_feet_dist];

robot.right_foot_position_bounds_ss = [
    -robot.max_step_len,    robot.max_step_len;
    -robot.max_feet_dist,   -robot.min_feet_dist];

%%%
% With respect to the center of preceding SS (fixed position)
robot.left_foot_position_fixed_ss = [
    0,    0;
    robot.feet_dist_default/2,   robot.feet_dist_default/2];

robot.right_foot_position_fixed_ss = [
    0,    0;
    -robot.feet_dist_default/2,   -robot.feet_dist_default/2];


%%%%
% With respect to the center of preceding SS (fixed_position)
robot.left_foot_position_fixed_ds = [
    0,    0;
    robot.feet_dist_default/2,    robot.feet_dist_default/2];

robot.right_foot_position_fixed_ds = [
    0,    0;
    -robot.feet_dist_default/2,   -robot.feet_dist_default/2];

%%%
robot.ss_rectangle = [
    -robot.foot_len/2,  robot.foot_width/2;
    robot.foot_len/2,   robot.foot_width/2;
    robot.foot_len/2,   -robot.foot_width/2;
    -robot.foot_len/2,  -robot.foot_width/2;
    -robot.foot_len/2,  robot.foot_width/2]';

robot.ds_rectangle = [
    -robot.foot_len/2,  (robot.foot_width + robot.feet_dist_default)/2;
    robot.foot_len/2,   (robot.foot_width + robot.feet_dist_default)/2;
    robot.foot_len/2,   -(robot.foot_width + robot.feet_dist_default)/2;
    -robot.foot_len/2,  -(robot.foot_width + robot.feet_dist_default)/2;
    -robot.foot_len/2,  (robot.foot_width + robot.feet_dist_default)/2]';

%%%
