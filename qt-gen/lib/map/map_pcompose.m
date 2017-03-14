function MAP=map_pcompose(P,MAPs)
% probabilistic composition of MAPs - MAP=map_pcompose(P,MAPs)
D0 = [];
D1 = [];
for i = 1:length(MAPs)
    if i==1
        
        D0 = MAPs{i}{1};
    else
        D0 = blkdiag(D0,MAPs{i}{1});
    end
    D1i = P(i,1)*MAPs{i}{2}*e(length(MAPs{i}{2}))*map_pie(MAPs{1});
    for j=2:length(MAPs)
        D1i = horzcat(D1i,MAPs{i}{2}*P(i,j)*e(length(MAPs{i}{2}))*map_pie(MAPs{j}));
    end
    D1 = vertcat(D1,D1i);
end

MAP = map_normalize({D0,D1});

end