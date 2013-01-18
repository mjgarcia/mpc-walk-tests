%%
% Robot
%%%
%   '"""""""""""""'                 \
%   |             |                  | max_feet_dist
%   ._____________.                  |
%                   } min_feet_dist /
%          * <- foot position
%   `^^^^^^' max_step_len
%%%
clear robot;
robot.max_step_len = 0.4;
robot.min_feet_dist = 0.10;
robot.max_feet_dist = 0.15;
robot.feet_dist_default = 0.10;
robot.h = 0.26; % Height of the CoM
robot.foot_len = 0.1;
robot.foot_width = 0.06;

%%%
robot.ss_zmp_bounds = [
    -robot.foot_len/2,      robot.foot_len/2;
    -robot.foot_width/2,    robot.foot_width/2];

robot.ds_zmp_bounds = [
    -robot.foot_len/2,      robot.foot_len/2;
    -(robot.foot_width + robot.feet_dist_default)/2,    (robot.foot_width + robot.feet_dist_default)/2];

%robot.dsl_zmp_bounds = [
%    -robot.foot_len/2,      robot.foot_len/2;
%    -(robot.foot_width/2 + robot.feet_dist_default),    robot.foot_width/2];
%
%robot.dsr_zmp_bounds = [
%    -robot.foot_len/2,      robot.foot_len/2;
%    -robot.foot_width/2,    robot.foot_width/2 + robot.feet_dist_default];

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

%robot.left_foot_position_fixed_ss = [
%    0,    0;
%    robot.feet_dist_default,   robot.feet_dist_default];
%
%robot.right_foot_position_fixed_ss = [
%    0,    0;
%    -robot.feet_dist_default,   -robot.feet_dist_default];

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

%robot.dsl_rectangle = [
%    -robot.foot_len/2,  robot.foot_width/2;
%    robot.foot_len/2,   robot.foot_width/2;
%    robot.foot_len/2,   -(robot.foot_width/2 + robot.feet_dist_default);
%    -robot.foot_len/2,  -(robot.foot_width/2 + robot.feet_dist_default);
%    -robot.foot_len/2,  robot.foot_width/2];
%
%robot.dsr_rectangle = [
%    -robot.foot_len/2,  (robot.foot_width/2 + robot.feet_dist_default);
%    robot.foot_len/2,   (robot.foot_width/2 + robot.feet_dist_default);
%    robot.foot_len/2,   -robot.foot_width/2;
%    -robot.foot_len/2,  -robot.foot_width/2;
%    -robot.foot_len/2,  (robot.foot_width/2 + robot.feet_dist_default)];
%%%
