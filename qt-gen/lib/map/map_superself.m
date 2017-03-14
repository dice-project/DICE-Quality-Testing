function [MAPS,SS]=map_superself(MAP,N)
% superposition of N identical MAPs

K=length(MAP{1});
SS = multichoose(K,N);

D0 = zeros(size(SS,1));
D1 = zeros(size(SS,1));

for s=1:size(SS,1)
    st = SS(s,:);
    for k=1:K
        for h=1:K
            dst = st;  
            dst(k) = dst(k) - 1;
            dst(h) = dst(h) + 1;
            d = matchrow(SS,dst);
            if d > 0
                % there is a valid transition from phase k to h
                D0(s,d) = D0(s,d) + MAP{1}(k,h)*st(k);
                D1(s,d) = D1(s,d) + MAP{2}(k,h)*st(k);
            end
        end
    end
end
MAPS = map_normalize({D0,D1});
end