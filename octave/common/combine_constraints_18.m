function [G_lb, G, G_ub, lambda_mask] = combine_constraints_18 (...
        Gzmp, Gzmp_ub, ...
        Gfd, Gfd_ub, ...
        Gt, Gt_ub, ...
        Gte, gte)

    load_constants

    G = [Gzmp(1:size(Gzmp,1)/2,:); Gfd(1:size(Gfd,1)/2,:); Gte];
    G_lb = [-Gzmp_ub(size(Gzmp,1)/2+1:end); -Gfd_ub(size(Gfd,1)/2+1:end); gte];
    G_ub = [Gzmp_ub(1:size(Gzmp,1)/2); Gfd_ub(1:size(Gfd,1)/2); gte];
    lambda_mask = [];
end