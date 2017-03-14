function [kurt] = map_count_kurt(MAP,t)
% Computes the kurtosis (fourth central moment) of counts for a MAP at
% temporal resolution t.

M = map_count_moment(MAP,t,1:4);
kurt=M(4)-4*M(3)*M(1)+6*M(2)*M(1)^2-3*M(1)^4;