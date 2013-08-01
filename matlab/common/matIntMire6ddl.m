%---------------------------------------%
% compute the interaction matrix
% associated to 5 points
% and for a 6ddl control
% Typically, a free 6ddl camera
%
% only the projection of the points in the
% image plane are known
%
% author : Claire Dune
% date : decembre 2009
%---------------------------------------%
function L = matIntMire6ddl(p,Zin)
  Z = 0;
  % point mire, 2 feature per point
  N = length(p);
  %----- test on Zin
  if (length(Zin)==N)
    Z = Zin;
    %disp('Z was a vector, no change')
  else
    Z = Zin*ones(N,1);
    %disp('Z was a scalar, create a vector, change')
  end
  L=[];
  for i=1:N
      L= [L; matIntPoint6ddl(p(1,i),p(2,i),Z(i))];
  end
end