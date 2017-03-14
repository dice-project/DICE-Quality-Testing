function [MAP] = map2_fit_count(rate, CV, t, method)
% INPUT
% - rate: arrival rate
% - CV: vector of count variance at different resolutions
% - t: vector of resolutions
% - method: optimization method
% OUTUT
% - MAP: acyclic second-order MAP

if nargin < 4
	method = 'fmincon'; 
end

options = struct('Algorithm', 'active-set', ...
                 'Display', 'none', ...
                 'MaxFunEvals', 10000);
x0 = [1.0, 1.0, 0.33, 0.5, 0.33];
Aineq = [0 0 1 0 1];
bineq = 1;
lb = [1e-6, 1e-6, 0, 0, 0];
ub = [1, 1, 1, 1, 1];
fprintf('Optimizing...\n');
if strcmp(method,'fmincon')
    xopt = fmincon(@compute_obj, ...
                   x0, ...
                   Aineq, bineq, [], [], ...
                   lb, ub, ...
                   [], options);
elseif strcmp(method,'gs_fmincon')
    problem = createOptimProblem('fmincon', ...
                                 'objective', @compute_obj, ...
                                 'x0', x0, ...
                                 'Aineq', Aineq, ...
                                 'bineq', bineq, ...
                                 'lb', lb, ...
                                 'ub', ub, ...
                                 'options', options);
    xopt = run(GlobalSearch,problem);
else
    error('Invalid method ''%s''\n', method);
end
MAP = assemble_map(xopt);
MAP = map_scale(MAP, 1/rate);

fprintf('Rate: input = %.3f, output = %.3f\n', ...
        rate, map_count_mean(MAP, t(1))/t(1) );
for i = 1:length(t)
    fprintf('Count var at resolution %e: input = %.3f, output = %.3f\n', ...
            t(i), CV(i), map_count_var(MAP, t(i)) );
end

    function obj = compute_obj(x)
        map = assemble_map(x);
        v = compute_map_var_count(map);
        obj = sum((v./CV - 1).^2);
    end

    function v = compute_map_var_count(map)
        v = zeros(length(t),1);
        factor = (rate*t(1)) / map_count_mean(map,t(1));
        for j = 1:length(t)
            v(j) = map_count_var(map,t(j) * factor);
        end
    end

    function map = assemble_map(x)
        h1 = x(1);
        h2 = x(2);
        r1 = x(3);
        r2 = x(4);
        r3 = x(5);
        % return MAP
        map = {[-1/h1, r1/h1; 0 -1/h2], ...
               [(1-r1-r3)/h1 r3/h1; (1-r2)/h2 r2/h2]};
         
    end

end