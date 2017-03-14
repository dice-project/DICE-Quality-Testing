function [M] = map_count_fmoment(MAP, t, order)
% Computes factorial moments of counts, at resolution t, of a MAP.
% INPUT
% - MAP: Markovian Arrival Process
% - t: resolution
% - order: orders of the moments to compute
% OUTPUT
% - M: factorial moments of counts

n = size(MAP{1},1);
theta = map_prob(MAP);

if map_issym(MAP)
    e = sym(ones(n,1));
    M = sym(zeros(length(order),1));
else
    e = ones(n,1);
    M = zeros(length(order),1);
end

if map_issym(MAP) || max(order) > 4
    % symbolic derivative
    z = sym('z');
    MZ = theta*expm(MAP{1}*t+MAP{2}*z*t)*e;
    for i = 1:length(order)
        M(i) = subs(diff(MZ,z,order(i)),z,1);
    end
else
    % numerical derivative
    for i = 1:length(order)
        M(i) = derivest(@(z) pgfunc(z), 1, 'deriv', order(i));
    end
end

    function r = pgfunc(z)
        r = zeros(length(z),1);
        for j = 1:length(z)
            r(j) = theta*expm(MAP{1}*t+MAP{2}*z(j)*t)*e;
        end
    end

end