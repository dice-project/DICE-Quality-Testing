function MAP=map_symblocksymm(K,symb1,symb2)
if nargin==1
    symb1='q';
    symb2='p';    
end
D0=diag(diag(randsym(K,K,symb1)));
P=randsymstochasticsymm(K,K,symb2);
MAP={D0,-D0*P};
MAP{2}=symeval(MAP{2},'p12=p')
MAP{2}=symeval(MAP{2},'p23=p')
MAP{2}=symeval(MAP{2},'p13=q')
MAP{1}=symeval(MAP{1},'q11=-mu1','q22=-mu2')
MAP{2}=symeval(MAP{2},'q22=-mu2','q11=-mu1')
MAP{1}=symeval(MAP{1},'q33=-(2+3^(1/2))*mu2*mu1/(mu2+mu1+3^(1/2)*mu1)')
MAP{2}=symeval(MAP{2},'q33=-(2+3^(1/2))*mu2*mu1/(mu2+mu1+3^(1/2)*mu1)')
MAP{1}=symeval(MAP{1},'mu1=(-1/t1)')
MAP{2}=symeval(MAP{2},'mu1=(-1/t1)')
MAP{1}=symeval(MAP{1},'mu2=(-1/t2)')
MAP{2}=symeval(MAP{2},'mu2=(-1/t2)')
end