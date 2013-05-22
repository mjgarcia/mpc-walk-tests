function [G, G_ub] = add_vs_constraints (G, G_ub, Gvs, Gvs_ub)

G = [G; Gvs];
G_ub = [G_ub; Gvs_ub];