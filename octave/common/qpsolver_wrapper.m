function [X, OBJ, INFO, LAMBDA, LAMBDA_MASK] = qpsolver_wrapper(soltype, H, q, Gzmp, Gzmp_ub, Gfd, Gfd_ub, Gb, Gb_ub, Gte, gte)
    default_soltype = 'qpoases';
%    default_soltype = 'octave';
    far_min_bound = -10^10;

    load_constants;


    LAMBDA_MASK = [ ones(length(gte), 1) * CONSTR_EQ;
                    ones(length(Gzmp_ub), 1) * CONSTR_ZMP;
                    ones(length(Gfd_ub), 1) * CONSTR_FD;
                    ones(length(Gb_ub), 1) * CONSTR_B];

    G = [   Gzmp; 
            Gfd; 
            Gb]; 

    G_ub = [    Gzmp_ub; 
                Gfd_ub; 
                Gb_ub];


    if (isempty(soltype))
        soltype = default_soltype;
    end

    if (strcmp(soltype, 'paranoid'))
        [X, OBJ, INFO, LAMBDA] = qpoases_wrapper(H, q, G, G_ub, Gte, gte, far_min_bound);
        [X_oct, OBJ_oct, INFO_oct, LAMBDA_oct] = octave_wrapper(H, q, G, G_ub, Gte, gte);

        printf('===============\n')
        printf('Status (qpOASES)\n')
        INFO.info
        printf('Status (Octave)\n')
        INFO_oct.info
        printf('Norm of the difference between solutions (qpOASES/Octave):\n')
        norm(X-X_oct)
        printf('===============\n')

    elseif (strcmp(soltype, 'qpoases'))
        [X, OBJ, INFO, LAMBDA] = qpoases_wrapper(H, q, G, G_ub, Gte, gte, far_min_bound);

    elseif (strcmp(soltype, 'octave'))
        [X, OBJ, INFO, LAMBDA] = octave_wrapper(H, q, G, G_ub, Gte, gte);

    else
        X = [];
        OBJ = [];
        INFO = [];
        LAMBDA = [];
        LAMBDA_MASK = [];

        printf('Unknown solver type!\n');
        return;
    end
end



function [X, OBJ, INFO, LAMBDA] = qpoases_wrapper(H, q, G, G_ub, Gte, gte, far_min_bound)
    G = [   Gte;
            G]; 

    G_lb = [    gte
                far_min_bound*ones(size(G_ub))];
    G_ub = [    gte;
                G_ub];

    addpath('../qpOASES');
    options = qpOASES_options( 'MPC' );
    options.enableDriftCorrection = 1;  % without this the error in constraint satisfaction is higher (^-12).
    options.printLevel = 0;

    tic();
    [X, OBJ, INFO.info, INFO.solveiter, LAMBDA] = qpOASES(H, q, G, [], [], G_lb, G_ub, [], options);
    INFO.exec_time = toc();

    LAMBDA = LAMBDA(length(X)+1:end);
end



function [X, OBJ, INFO, LAMBDA] = octave_wrapper(H, q, G, G_ub, Gte, gte)
    OPTIONS.MaxIter = 5000;

    tic();
    [X, OBJ, INFO, LAMBDA] = qp ([], H, q, Gte, gte, [], [], [], G, G_ub, OPTIONS);
    INFO.exec_time = toc();
end
