function MAP=map_randblock_circul(K)
D0=-inv(diag(rand(1,K)));
p(1)=rand;
for i=2:K-1
    p(i)=(1-sum(p(1:(i-1))))*rand;
end
p(K)=1-sum(p(1:(K-1)));
P=circul(p)
MAP={D0,-D0*P};
end