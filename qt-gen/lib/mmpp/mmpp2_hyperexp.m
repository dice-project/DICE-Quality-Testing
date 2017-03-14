function MMPP2=mmpp2_hyperexp(mean,SCV,p)
x=solve(sprintf('%d*SA+(1-%d)*SB-%d',p,p,mean),sprintf('2*(%d*SA^2+(1-%d)*SB^2)-%d',p,p,(1+SCV)*mean^2),'SA,SB');
mu1=1/double(x.SA(1));
mu2=1/double(x.SB(1));

lambda = p*mu1 + (1-p)*mu2;

q01=(p*(1-p)*(mu1-mu2)^2)/lambda;
q10=mu1*mu2/lambda;

MMPP2={[-q01-lambda,q01;q10,-q10],[lambda,0;0,0]};

if map_isfeasible(MMPP2)>12
    return;
end

mu1=1/double(x.SA(2));
mu2=1/double(x.SB(2));
lambda = p*mu1 + (1-p)*mu2;

q01=(p*(1-p)*(mu1-mu2)^2)/lambda;
q10=mu1*mu2/lambda;

MMPP2={[-q01-lambda,q01;q10,-q10],[lambda,0;0,0]};

end