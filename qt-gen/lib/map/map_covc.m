function covc=map_covc(MAP,kset,u)
% u = length of slot
n = length(MAP{1});
Q = map_infgen(MAP);
I = eye(n);
piq = map_piq(MAP);
PRE = piq*MAP{2}*(I-expm(Q*u));
POST = (I-expm(Q*u))*(ones(n,1)*piq-Q)^(-2)*MAP{2}*ones(n,1);
covc=zeros(1,length(kset));
for j=1:length(kset)
    covc(j)=PRE * expm(Q*(kset(j)-1)*u) * POST;
end
end