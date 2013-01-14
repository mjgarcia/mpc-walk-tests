function [O] = rotate_translate(D, R, p)
    for i = 1:size(D,2)
        O(:,i) = R * D(:,i) + p;
    end
end
