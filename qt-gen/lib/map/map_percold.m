function pt=map_perc(MAP,percentile)
syms t real;
cdf=@(t) (1-(1/map_lambda(MAP))*map_prob(MAP)*MAP{2}*expm(MAP{1}*t)*ones(length(MAP{2}),1) -percentile)^2;
pt=fminbnd(cdf,0,1e3*map_mean(MAP));

end