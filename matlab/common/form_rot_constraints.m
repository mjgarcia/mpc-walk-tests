function [G_rot, G_rot_ub] = form_rot_constraints (D1, D2, Up, S0p_rot, theta_max)

D2mD1 = D2 - D1;
D2mD1bS0p = D2mD1*S0p_rot;

G_rot1 = D2mD1*Up;
G_rot_ub1 = theta_max - D2mD1bS0p;

G_rot2 = -G_rot1;
G_rot_ub2 = theta_max + D2mD1*S0p_rot;

G_rot = [G_rot1; G_rot2];
G_rot_ub = [G_rot_ub1; G_rot_ub2];