function [G_rot, G_rot_ub] = form_rot_constraints (mpc_rot, mpc_state_rot, D1, D2, Up, S0p_rot, Uv, S0v_rot)

% Maximum angle betweenn feet and trunk
D2mD1 = D2 - D1;
D2mD1bS0p = D2mD1*S0p_rot;

G_rot1 = D2mD1*Up;
G_rot_ub1 = mpc_state_rot.theta_max_feet_com - D2mD1bS0p;

G_rot2 = -G_rot1;
G_rot_ub2 = mpc_state_rot.theta_max_feet_com + D2mD1*S0p_rot;

% % Maximum overshoot
% if mpc_state_rot.cstate(1) < mpc_state_rot.ref_pos
%     G_rot3 = D1*Up;
%     G_rot_ub3 = (mpc_state_rot.ref_pos + mpc_state_rot.theta_margin)*ones(mpc_rot.N,1) - D1*S0p_rot;
% else
%     G_rot3 = -D1*Up;
%     G_rot_ub3 = (-mpc_state_rot.ref_pos + mpc_state_rot.theta_margin)*ones(mpc_rot.N,1) + D1*S0p_rot;
% end

% % Maximum velocity
% G_rot4 = Uv;
% G_rot_ub4 = mpc_state_rot.max_vel*ones(mpc_rot.N*mpc_rot.Nu,1) - S0v_rot;
% 
% G_rot5 = -Uv;
% G_rot_ub5 = mpc_state_rot.max_vel*ones(mpc_rot.N*mpc_rot.Nu,1) + S0v_rot;
% 
% G_rot = [G_rot1; G_rot2; G_rot3; G_rot4; G_rot5];
% G_rot_ub = [G_rot_ub1; G_rot_ub2;  G_rot_ub3; G_rot_ub4; G_rot_ub5];

%G_rot = [G_rot1; G_rot2; G_rot3];
%G_rot_ub = [G_rot_ub1; G_rot_ub2;  G_rot_ub3];

G_rot = [G_rot1; G_rot2];
G_rot_ub = [G_rot_ub1; G_rot_ub2];