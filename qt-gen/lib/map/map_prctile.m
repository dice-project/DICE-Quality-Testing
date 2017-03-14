function pt=map_perc(MAP,percentile,tol)
if nargin==2
    tol=0.01;
end
% pt=map_perc(MAP,percentile) - computes percentile the input value percentile should be in [0,100]
n=length(MAP{2});
percentile=percentile+1;
step=map_mean(MAP)/1e4;
pie=map_pie(MAP);
t=0;
step=1000*map_mean(MAP);
diff=Inf;
while diff>tol
    step=step/2;
    diff=(1-pie*expm(MAP{1}*(t+step))*e(n))-(1-pie*expm(MAP{1}*t)*e(n));
end
diff=Inf;
while diff > tol
    t=t+step;
    diff=abs((1-pie*expm(MAP{1}*(t+step))*e(n))-percentile/100);
end
%fprintf(1,'CDF value:%f\n',map_cdf(MAP,t));
pt=t;
end