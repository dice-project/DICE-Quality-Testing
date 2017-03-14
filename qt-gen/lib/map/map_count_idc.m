function idc = map_count_idc(map, t)
% Computes the Index of Dispersion of Counts for the given MAP at
% resolution t.

idc = map_count_var(map,t)./map_count_mean(map,t);

end