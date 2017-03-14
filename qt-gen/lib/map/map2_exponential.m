function MAP=map2_exponential(MEAN)
mu11=rand;
mu22=rand;
mu12=mu22*rand;
mu21=rand;
q21=rand;
mu11=mu22-mu12+mu21;
q12 = mu12*q21/mu21;

D0=[ - mu11 - mu12 - q12, q12; q21, - mu21 - mu22 - q21];
D1=[ mu11, mu12; mu21, mu22];
MAP=map_scale({D0,D1},MEAN);

end