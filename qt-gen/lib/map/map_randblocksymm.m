function MAP=map_randblocksymm()
mu1=rand;
mu2=rand;
p=rand;
MAP=map_normalize({[0,0;0,0],[mu1*p,mu1*(1-p);mu2*(1-p),mu2*p]});
end