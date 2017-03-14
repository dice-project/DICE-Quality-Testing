function [FIT] = mmpp2_fit_count_approx(a, bt1, bt2, binf, m3t2, ...
                                        t1, t2)
% Fits a second-order Marked MMPP.
% a: arrival rate
% bt1: IDC at scale t1
% bt2: IDC at scale t2
% binf: IDC for t->inf
% m3t2: third central moment
% t1: first time scale
% t2: second time scale

method_d0d1 = 'exact';

options = struct('Algorithm', 'active-set', ...
                 'Display', 'none', ...
                 'MaxFunEvals', 100000);
% l1, l2, r1, r2 (rate is fitted exactly)
x0 = [a*3/4, a*3/2, 1/3, 2/3];
lb = [1e-6, 1e-6, 0, 0];
ub = [inf, inf, inf, inf];
fprintf('Fitting unified counting process...\n');
if strcmp(method_d0d1,'fmincon') == 1
    [xopt,fxopt] = fmincon(@compute_obj, ...
                           x0, ...
                           [], [], ... % linear inequalities
                           [], [], ... % linear equalities
                           lb, ub, ... % bounds
                           [], options);
    fprintf('Unified fitting error: %f\n', fxopt);
    FIT = assemble_mmap(xopt);
elseif strcmp(method_d0d1,'gs_fmincon') == 1
    problem = createOptimProblem('fmincon', ...
                                 'objective', @compute_obj, ...
                                 'x0', x0, ...
                                 'lb', lb, ...
                                 'ub', ub, ...
                                 'options', options);
    [xopt,fxopt] = run(GlobalSearch,problem);
    fprintf('Unified fitting error: %f\n', fxopt);
    FIT = assemble_mmap(xopt);
elseif strcmp(method_d0d1,'exact') == 1
    FIT = mmpp2_fit_count(a, bt1, bt2, binf, m3t2, t1, t2);
    if isempty(FIT)
        % this occurs when IDC(t) < 1
        error('Feasibility cannot be repaired.'); 
    end
else
    error('Invalid method ''%s''\n', method);
end

fa = map_count_mean(FIT,1);
fprintf('Forcing exact rate: from %f to %f\n', fa, a);
FIT = map_scale(FIT, 1/a);

fa = map_count_mean(FIT,1);
fbt1 = map_count_var(FIT,t1)/map_count_mean(FIT,t1);
fbt2 = map_count_var(FIT,t2)/map_count_mean(FIT,t2);
fbinf = map_count_var(FIT,1e8)/map_count_mean(FIT,1e8);
fmt2 = map_count_moment(FIT,t2,1:3);
fm3t2 = fmt2(3) - 3*fmt2(2)*fmt2(1) + 2*fmt2(1)^3;
fprintf('Rate: input = %.3f, output = %.3f\n', a, fa);
fprintf('IDC(t1): input = %.3f, output = %.3f\n', bt1, fbt1);
fprintf('IDC(t2): input = %.3f, output = %.3f\n', bt2, fbt2);
fprintf('IDC(inf): input = %.3f, output = %.3f\n', binf, fbinf);
fprintf('M3(t2): input = %.3f, output = %.3f\n', m3t2, fm3t2);

    function obj = compute_obj(x)
        % compute characteristics
        xa = compute_rate(x);
        factor = a/xa;
        xbt1 = compute_idc(x, t1*factor);
        xbt2 = compute_idc(x, t2*factor);
        xbinf = compute_idc_limit(x);
        xm3t2 = compute_m3(x,xa,xbt2,xbinf,t2*factor);
        % compute objective
        obj = 0;
        obj = obj + (xa/a-1)^2;
        obj = obj + (xbt1/bt1-1)^2;
        obj = obj + (xbt2/bt2-1)^2;
        obj = obj + (xbinf/binf-1)^2;
        obj = obj + (xm3t2/m3t2-1)^2;
    end

    function xa = compute_rate(x)
        l1 = x(1);
        l2 = x(2);
        r1 = x(3);
        r2 = x(4);
        xa = (l1*r2 + l2*r1)/(r1 + r2);
    end

    function xbt = compute_idc(x,t)
        l1 = x(1);
        l2 = x(2);
        r1 = x(3);
        r2 = x(4);
        xbt = (r1*(2*l1^2*r2^2*t - 2*l2^2*r2 - 2*l1^2*r2 + 2*l2^2*r2^2*t + 4*l1*l2*r2 + 2*l1^2*r2*exp(- r1*t - r2*t) + 2*l2^2*r2*exp(- r1*t - r2*t) - 4*l1*l2*r2^2*t - 4*l1*l2*r2*exp(- r1*t - r2*t)) + r1^2*(2*r2*t*l1^2 - 4*r2*t*l1*l2 + 2*r2*t*l2^2))/(t*(r1 + r2)^3*(l1*r2 + l2*r1)) + 1; 
    end

    function xbinf = compute_idc_limit(x)
        l1 = x(1);
        l2 = x(2);
        r1 = x(3);
        r2 = x(4);
        xbinf = ((2*r2*l1^2 - 4*r2*l1*l2 + 2*r2*l2^2)*r1^2 + (2*l1^2*r2^2 - 4*l1*l2*r2^2 + 2*l2^2*r2^2)*r1)/((r1 + r2)^3*(l1*r2 + l2*r1)) + 1;
    end

    function xm3t = compute_m3(x,xa,xbt,xbinf,t)
        l1 = x(1);
        l2 = x(2);
        r1 = x(3);
        r2 = x(4);
        d = r1+r2;
        p = (l1-l2)*(r1-r2);
        xg3t = xa^3*t^3 + ...
               3*xa^2*(xbinf-1)*t^2 + ...
               3*xa*(xbinf-1)/d*(p/d-xa)*t + ...
               3*xa/d^2*(xbinf-1)*(p + xa*d)*t*exp(-t*d) - ...
               6*xa/d^3*(xbinf-1)*p*(1-exp(-t*d));
        xm3t = xg3t - 3*xa*t*(xa*t-1)*xbt - xa*t*(xa*t-1)*(xa*t-2);
    end

    function mmap = assemble_mmap(x)
        % extract parameters
        l1 = x(1);
        l2 = x(2);
        r1 = x(3);
        r2 = x(4);
        % assemble
        D0 = [-(l1+r1), r1; r2, -(l2+r2)];
        D1 = [l1 0; 0 l2];
        mmap = {D0, D1};
    end

end