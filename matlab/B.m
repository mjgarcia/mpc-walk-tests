function out = B(T)
    out = [ T^3/6   0;
            T^2/2   0;
            T       0;
            0       T^3/6;
            0       T^2/2;
            0       T];
end % EOF B