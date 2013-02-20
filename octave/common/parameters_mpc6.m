%%
% MPC
clear mpc;
mpc.Ns = 6;     % Number of state variables
mpc.Nu = 2;     % Number of control variables
mpc.Nz = 2;     % 
mpc.N = 16;     % length of the preview window (iterations)
mpc.T = 0.1;    % duration of one iteration (second)
%{
mpc.alpha = 1;      %
mpc.beta = 0.00001;    %   
mpc.gamma = 0.0001;      %
%}
mpc.alpha = 1;      %
mpc.beta = 0.001;    %   
mpc.gamma = 0.0001;      %

%mpc.alpha = 1;      %
%mpc.beta = 0.001;    %   
%mpc.gamma = 10;      %
%{
      CopCentering[0]    = 0.0001;
      JerkMin[0]         = 0.001;
      instantVelocity[0] = 1; // walking

      CopCentering[1]    = 10;
      JerkMin[1]         = 0.001;
      instantVelocity[1] = 1; // standing
%}
%%


function out = A(T)
    out = [ 1   T   T^2/2   0   0   0;
            0   1   T       0   0   0;
            0   0   1       0   0   0;
            0   0   0       1   T   T^2/2;
            0   0   0       0   1   T;
            0   0   0       0   0   1];
end % EOF A


function out = B(T)
    out = [ T^3/6   0;
            T^2/2   0;
            T       0;
            0       T^3/6;
            0       T^2/2;
            0       T];
end % EOF B

