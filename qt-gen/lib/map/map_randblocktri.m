function MAP=map_randblocktri(K,symb1,symb2)
D0=-diag(1./diag(rand(K)));
P=randstochastic(K);
P=diag(diag(P,1),1)+diag(diag(P,0),0)+diag(diag(P,-1),-1);
P=makestochastic(P);
MAP={D0,-D0*P};
end