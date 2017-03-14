function IDCt=map_idct(MAP,tset)
% validated
D0=MAP{1};
D1=MAP{2};
invD0=inv(-D0);
P=invD0*D1;
pie=map_pie(MAP);
piq=map_piq(MAP);
n=length(MAP{1});
if issym(MAP{1})
    e=sym(ones(n,1))    ;
else
    e=ones(n,1);
end
PI=e*map_prob(MAP);
l=map_lambda(MAP);
pi=map_prob(MAP);

IDCinf=map_idc(MAP); % 1-2*l+(2/l)*pi*D1*inv(PI-D0-D1)*D1*e
for i=1:length(tset)
    if tset(i)==0
        IDCt(i)=0;
    else
    IDCt(i)=IDCinf-2*pi*D1*(eye(n)-expm((D0+D1)*tset(i)))*inv((PI-D0-D1)^2)*D1*e/(l*tset(i));
    end
end

end