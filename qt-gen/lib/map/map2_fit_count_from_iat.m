function [MAP] = map2_fit_count_from_iat(T,method)

% decide resolutions
ttime = sum(T);
samples = length(T);
min_t = ttime * 10/samples; % average of 10 samples
max_t = ttime * 1/10; % average of 10% samples
t = logspace(log10(min_t), log10(max_t),4)';

% compute the counting process for different resolutions
N = cell(length(t),1);
CM = zeros(length(t),1);
CV = zeros(length(t),1);
for i = 1:length(t)
    fprintf('Computing counting process at resolution %e: ', t(i));
    N{i} = trace_iat2counts(T, t(i));
    CM(i) = mean(N{i});
    CV(i) = var(N{i});
    fprintf('mean = %f, var = %f\n', CM(i), CV(i));
end

% compute average at different resolutions
rate = mean(CM ./ t);
fprintf('Estimated rate: %f\n', rate);

if nargin < 2
    MAP = map2_fit_count(rate, CV, t);
else
    MAP = map2_fit_count(rate, CV, t, method);
end