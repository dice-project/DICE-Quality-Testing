function [ERR]=map2_fittable(e1,e2,e3,g2)
% A. Heindl, G.Horvath, K. Gross "Explicit inverse characterization of
% acyclic MAPs of second order"

ERR=0;
r1=e1; r2=e2/2;
h2=(r2-r1^2)/r1^2;
if e3==-1
    % select e3 that maximizes the range of correlations
    scv=(e2-e1^2)/e1^2;
    if 1<=scv && scv<3
        if g2<0
            h3=h2-h2^2; %b=0
            e3=12*e1^3*h2+6*e1^3*h3+6*e1^3*(1+h2^2);
        else
            e3=(3/2+1e-3)*e2^2/e1;
        end
    elseif 3<=scv
        e3=(3/2+1e-3)*e2^2/e1;
    elseif 0<scv && scv<1
        e3=(1+1e-10)*(12*e1^3*h2+6*e1^3*(h2*(1-h2-2*sqrt(-h2)))+6*e1^3*(1+h2^2));
    end
end
r3=e3/6;
h3=(r3*r1-r2^2)/r1^4;
b=h3+h2^2-h2;
c=sqrt(b^2+4*h2^3);

if r1<=0
    ERR=10; % mean out of bounds
    return
end

if h2==0
    if h3==0 && g2==0
        ERR=0;
        return
    else
        ERR=20; % correlated exponential
        return
    end
end

tol=1e-8;
if h2>0 && h3>0
    map_fit_hyper();
    return
elseif -1/4-tol<=h2 && h2<0 && h2*(1-h2-2*sqrt(-h2))-tol<=h3 && h3<=-h2^2+tol
    map_fit_hypo();
    return
else
    if ~(-1/4-tol<=h2 && h2<0 && h2*(1-h2-2*sqrt(-h2))-tol<=h3 && h3<=-h2^2+tol)
        ERR=30; % h2 out of bounds
        return
    elseif (h2>0 && h3<0) || h2*(1-h2-2*sqrt(-h2))-tol>h3 || h3<=-h2^2+tol
        ERR=40; % h3 out of bounds
        return
    else
        error('I lost an error')
    end
end

    function map_fit_hyper()
        if b>=0
            if (b-c)/(b+c)<=g2 && g2<1
                ERR=0;
                return
            else
                ERR=51; % g2 out of bounds
                return
            end
        elseif b<0
            if 0<=g2 && g2<1
                ERR=0;
                return
            elseif -(h3+h2^2)/h2 <= g2 && g2<0
                ERR=0;
                return
            else
                ERR=52; % g2 out of bounds
                return
            end
        end
    end
    function map_fit_hypo()
        if g2>=0
            if g2<=-(h2+sqrt(-h3))^2/h2
                ERR=0;
                return
            else
                ERR=53; % g2 out of bounds
                return
            end
        elseif g2<0
            if g2 >= -(h3+h2^2)/h2
                ERR=0;
                return
            else
                ERR=54; % g2 out of bounds
                return
            end
        end
    end
end