function [MAP]=map_randblock(K)
if nargin<1
    K=2;
end
P=randstochastic(K);
D0=-abs(diag(log(1+log(diag(abs(rand(K)))))));
MAP={D0,-D0*P};
MAP=map_normalize(MAP);
end


