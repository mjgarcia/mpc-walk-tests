function out = A(T)
    out = [ 1   T   T^2/2   0   0   0;
            0   1   T       0   0   0;
            0   0   1       0   0   0;
            0   0   0       1   T   T^2/2;
            0   0   0       0   1   T;
            0   0   0       0   0   1];
end % EOF A
