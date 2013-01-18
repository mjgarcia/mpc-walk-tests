function [Gb, Gb_ub] = form_feet_constraint_14(robot, mpc, mpc_state, constr, Nfp);
    load_constants

    GF = [];
    R = [];
    V = zeros(Nfp);
    b_points = [];


    Ni = mpc_state.counter;
    for i = 1:Nfp/2;
        Ni = Ni + mpc_state.pwin(Ni + 1).support_len;


        GF = blkdiag(GF, constr(1:2));
        R = blkdiag(R, mpc_state.pwin(Ni + 1).R);
        V = V + diag(ones(Nfp - (i-1)*mpc.Nz,1),  -(i - 1)*mpc.Nz);

        if (mpc_state.pwin(Ni + 1).support_type == DS);
            b_points = [b_points; robot.ds_rectangle(:,1:4)];
        else
            b_points = [b_points; robot.ss_rectangle(:,1:4)];
        end
    end


    Gb = [zeros(Nfp/2, mpc.N*mpc.Nu),  GF * V];
    Gb = [Gb; Gb; Gb; Gb];


    for i = 1:Nfp/2;
    end


    Gb_ub = [];
    if (Nfp > 0)
        for i=1:4;
            Gb_ub = [Gb_ub; 
                    constr(3) - GF * (R * b_points(:, i)  + repmat(mpc_state.p, Nfp/2, 1))];
        end
    end
end
