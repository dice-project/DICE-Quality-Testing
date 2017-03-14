function F=map_ccdf(MAP,tset)
F=[];
for t=tset
    F(end+1)=(1/map_lambda(MAP))*map_prob(MAP)*MAP{2}*expm(MAP{1}*t)*ones(length(MAP{2}),1);
end
end