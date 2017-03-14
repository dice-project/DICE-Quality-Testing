function MAP=map_symblock(K,symb1,symb2)
if nargin==1
    symb1='q';
    symb2='p';    
end
D0=-diag(1./diag(randsym(K,K,symb1)));
P=randsymstochastic(K,K,symb2);
MAP={D0,-D0*P};
end