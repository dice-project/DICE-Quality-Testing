function MAP=map_symblocktri(K,symb1,symb2)
if nargin==1
    symb1='q';
    symb2='p';    
end
D0=-diag(1./diag(randsym(K,K,symb1)));
P=randsymstochastic(K,K,symb2);
P=diag(diag(P,1),1)+diag(diag(P,0),0)+diag(diag(P,-1),-1);
MAP={D0,-D0*P};
end