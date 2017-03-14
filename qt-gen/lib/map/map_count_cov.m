function [c] = map_count_cov(map, t, k)
% Computes the variance of the counting process, at resolution t, for the
% given MAP.
% Input:
% - map: Marovian Arrival Process (symbolic or numeric)
% - t: resolution
% - k: slots separated by k-1
% Output:
% - c: covariance (rows: different resolution, columns: different lag)
% Reference: [Casale, Building Accurate Workload Models Using MAPs, 2011]
% Verified special case of MMPP(2) with [Andresen and Nielsen, 1998].

n = size(map{1},1);

if map_issym(map)
    I = sym(eye(n));
    e = sym(ones(n,1));
    c = sym(zeros(length(t),length(k)));
else
    I = eye(n);
    e = ones(n,1);
    c = zeros(length(t),length(k));
end

D = map{1} + map{2};
theta = map_prob(map);
d2 = (e * theta - D)^(-2) * map{2} * e;

for i=1:length(t)
    T = t(i);
    tmp = (I - expm(D*T));
    for j=1:length(k)
        K = k(j);
        c(i,j) = theta * map{2} * tmp * expm(D*(K-1)*T) * tmp * d2;
    end
end

end