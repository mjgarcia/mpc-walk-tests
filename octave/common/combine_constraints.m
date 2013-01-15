function [Ge, ge, G, G_ub, lambda_mask] = combine_constraints (...
        Gzmp, Gzmp_ub, ...
        Gfd, Gfd_ub, ...
        Gt, Gt_ub, ...
        Gte, gte)

    load_constants

    Ge = [];
    ge = [];
    G = [];
    G_ub = [];

    lambda_mask = [];

% EQ
    Ge = Gte;
    ge = gte;
    lambda_mask = [lambda_mask; ones(length(gte), 1) * CONSTR_EQ];

% ZMP
    G = [G; Gzmp];
    G_ub = [G_ub; Gzmp_ub];
    lambda_mask = [lambda_mask; ones(length(Gzmp_ub), 1) * CONSTR_ZMP];

% FD
    G = [G; Gfd];
    G_ub = [G_ub; Gfd_ub];
    lambda_mask = [lambda_mask; ones(length(Gfd_ub), 1) * CONSTR_FD];

% TC
    G = [G; Gt];
    G_ub = [G_ub; Gt_ub];
    lambda_mask = [lambda_mask; ones(length(Gt_ub), 1) * CONSTR_TC];
end
