function [MAP]=map_sym(K)
D1=randsym(K,K,'mu');
D0=randsym(K,K,'q');
MAP={D0,D1};
for n=1:K
    % recalculate the diagonal elements in D0 according to the other
    % elements in the same row
    MAP{1}(n,n)=0;
    for b=1:2
        MAP{1}(n,n)=MAP{1}(n,n)-sum(MAP{b}(n,:));
    end
end
end
