function MAP=map_erlangmu(mu,k)
MAP={zeros(k),zeros(k)};
% compute D0
for i=1:k-1
    MAP{1}(i,i+1)=mu;
end
% compute D1
MAP{2}(k,1)=mu;
% normalize D0 diagonal
MAP=map_normalize(MAP);
end