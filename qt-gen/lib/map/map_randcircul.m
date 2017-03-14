function [MAP]=map_randcircul(K,level)
if nargin<1
    K=2;
end
v = abs(randn(1,K)); v(1:K-1) = 0;
D0=circul(v);
MAP={D0,full(rand(K))};
MAP=map_normalize(MAP);
end


