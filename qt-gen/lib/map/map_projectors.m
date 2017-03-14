function [M,sM,A,sA,J1,sJ2,mJ2]=map_projectors(MAP,OPT)
% [M,sM,A,sA]=map_projectors(MAP)
if nargin==1
    OPT='';
end
P=map_embedded(MAP);
invD0=-inv(MAP{1});
[sM,mM]=spectd(invD0,OPT);
if issym(MAP{1})
    M=sym(zeros(1,length(mM)));
else
    M=zeros(1,length(mM));
end
for i=1:length(mM)
    M(i)=map_momentnorm(MAP,mM{i});
end
if nargout>2
    [sA,mA]=spectd(P,OPT);
    if issym(MAP{1})
        A=sym(zeros(1,length(mA)));
    else
        A=zeros(1,length(mA));
    end
    for i=1:length(mA)
        A(i)=map_acfnorm(MAP,mA{i});
    end
end
if nargout>4
    J1=A*map_mean(MAP)^2*map_scv(MAP); % autocovariance projectors
    if ~issym(MAP{1})
        sM=sM(:)';
        sA=sA(:)';
        M(find(abs(M)<10*eps))=0;
        A(find(abs(A)<10*eps))=0;
    end
    [sJ2,mJ2]=spectd(invD0*P*invD0*P*invD0);
end
end

function A=map_momentnorm(MAP,m)
pie=map_pie(MAP);
n=length(MAP{1});
A=pie*m*e(n);
end

function A=map_acfnorm(MAP,m)
E1=map_mean(MAP);
pie=map_pie(MAP);
invD0=-inv(MAP{1});
n=length(MAP{1});
SCV=map_scv(MAP);
A=(E1^-2)*pie*invD0*m*invD0*e(n)/SCV;
%A=pie*invD0*m*invD0*e(n)
end