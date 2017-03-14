function IDIt=map_idin(MAP,nset)
% validated
D0=MAP{1};
D1=MAP{2};
invD0=inv(-D0);
P=invD0*D1;
pie=map_pie(MAP);
n=length(MAP{1});
if issym(MAP{1})
    e=sym(ones(n,1));
else
    e=ones(n,1);
end
pie=map_pie(MAP);
P1=e*pie;
l=map_mean(MAP)^-1;
IDIinf=map_idc(MAP); %2*l^2*pie*invD0*inv(eye(n)+P1-P)*invD0*e-1;
%IDCinf=map_idc(MAP); %1-2*l+(2/l)*pi*D1*inv(PI-D0-D1)*D1*e
for i=1:length(nset)
    if nset(i)==0
        IDIt(i)=0;
    elseif nset(i)==Inf
        IDIt(i)=IDIinf;
    else
        if isnan(P(1,1))
            IDIt(i)=0;
        else
        IDIt(i)=IDIinf-(2/nset(i))*l^2*pie*invD0*(eye(n)-P^nset(i))*inv((eye(n)-P+P1)^2)*P*invD0*e;
        end
    end
end

end