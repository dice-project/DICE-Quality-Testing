function [skew] = map_count_skew(map,t)
% Computes the skewness (third central moment) of counts for a MAP, at
% resolution t.

M = map_count_moment(map,t,1:3);
skew = M(3) - 3*M(1)*M(2) + 2*M(1)^3;