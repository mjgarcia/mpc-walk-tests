function [S,U] = form_S_U(A, B, mpc, mpc_state)
%
% form S and U in X = S*x0 + U*J
%
    N = mpc.N;
    Nx = mpc.Ns;
    Nu = mpc.Nu;
    Ni = mpc_state.counter;

    % --------------------------------------------------------------------------------------------

    % form S
    S = zeros(Nx*N,Nx);
    for i = 1:N
        ind_x = Nx*(i-1)+1:Nx*i;
        S(ind_x,:) = eye(Nx);
        for k = 1:i
            S(ind_x,:) = A(mpc_state.pwin(Ni + k).T)*S(ind_x,:);
        end
    end

    % form U
    U = zeros(Nx*N,Nu*N);
    for i = 1:N % column
        ind_u = Nu*(i-1)+1:Nu*i;
        for j = i:N % row
            ind_x = Nx*(j-1)+1:Nx*j;
            U(ind_x,ind_u) = B(mpc_state.pwin(Ni + i).T);
            for k = i+1:j
                U(ind_x,ind_u) = A(mpc_state.pwin(Ni + k).T)*U(ind_x,ind_u);
            end
        end
    end
end % EOF form_preview_dyn
