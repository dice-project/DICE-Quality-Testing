function [MAP_FIT] = map2_fit_count_theoretical(MAP, t, method)
% Fits the theoretical characteristics of the counting process of a MAP.
% INPUT:
% - MAP: the Markovian Arrival Process
% - t: the resolutions of the counting process to fit
% - method: (optional) optimizatin method, see map2_fit_count
% OUTPUT:
% - MAP_FIT: the fitted MAP

rate = 1/map_mean(MAP);

CV = zeros(length(t),1);
for i = 1:length(t)
    CV(i) = map_count_var(MAP, t(i));
end

if nargin < 3
    MAP_FIT = map2_fit_count(rate, CV, t);
else
    MAP_FIT = map2_fit_count(rate, CV, t, method);
end