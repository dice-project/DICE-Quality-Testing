function MAP=map_hypo(mu,k)
if nargin==1
    k=length(mu);
end
D0=zeros(k);D1=zeros(k);
if issym(mu(1))
    D0=sym(D0); D1=sym(D1);
else
end
for i=1:k-1
    D0(i,i+1)=mu(i);
end
D1(k,1)=mu(k);
MAP=map_normalize({D0,D1});
end