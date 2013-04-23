function draw_line(coef, color, width)
    xlim = get (gca (), "xlim");
    ylim = get (gca (), "ylim");


    p = [];

    if (coef(2) != 0)
        A = [coef(1:2); 1 0];
        b1 = [coef(3); xlim(1)];
        b2 = [coef(3); xlim(2)];

        p1 = A \ b1;
        p2 = A \ b2;


        if (p1(2) >= ylim(1)) && (p1(2) <= ylim(2))
            p = [p p1]; 
        end

        if (p2(2) >= ylim(1)) && (p2(2) <= ylim(2))
            p = [p p2]; 
        end
    end

    if (coef(1) != 0)
        A = [coef(1:2); 0 1];
        b1 = [coef(3); ylim(1)];
        b2 = [coef(3); ylim(2)];

        p1 = A \ b1;
        p2 = A \ b2;

        if (p1(1) >= xlim(1)) && (p1(1) <= xlim(2))
            p = [p p1]; 
        end

        if (p2(1) >= xlim(1)) && (p2(1) <= xlim(2))
            p = [p p2]; 
        end
    end


%    hold on

    p = round(p*1000)/1000;
    p = unique(p', 'rows')';
    if size(p) == [2, 2];
        if nargin < 3;
            width = 2;
        end
        if nargin < 2
            color = 'r';
        end
        plot(p(1,1:2), p(2,1:2), color, 'linewidth', width)
    end

%    hold off
end
