function plot_constraint_actpattern(simdata, shuffle_type = 'default')
    load_constants
    load_plotting_options

    binmat = [];
    for i=1:length(simdata.simstep)
        binmat = [binmat, (simdata.simstep(i).lambda_zmp != 0)];
    end


    % shuffle lines
    constr_num = length(simdata.simstep(i).lambda_zmp);
    if (strcmp(shuffle_type, 'default'))
        ind3 = 1:constr_num;
    elseif (strcmp(shuffle_type, 'group_support'))
        ind1 = 1:2:constr_num;
        ind2 = 2:2:constr_num;
        ind3 = eye(constr_num)(:,ind1) * [1:constr_num/2]' + eye(constr_num)(:,ind2) * [constr_num/2+1:constr_num]';
    elseif (strcmp(shuffle_type, 'group_coord'))
        ind1 = 1:2:constr_num/2;
        ind2 = 2:2:constr_num/2;
        ind3 = [eye(constr_num/2)(ind1,:) * [1:constr_num/2]';
                eye(constr_num/2)(ind2,:) * [constr_num/2+1:constr_num]';
                eye(constr_num/2)(ind2,:) * [1:constr_num/2]';
                eye(constr_num/2)(ind1,:) * [constr_num/2+1:constr_num]'];
    end
    

    spy(binmat(ind3,:), 15);
    xlabel('iteration of simulation');
    ylabel('number of constraint');
    axis('xy');
    grid on;
%    axis equal;
end
