function [sP,J1,J2,J3]=map_jointprojectors(MAP)
% [M,sM,A,sA]=map_projectors(MAP)
P=map_embedded(MAP);
pie=map_pie(MAP);
invD0=-inv(MAP{1});
[sP,mP]=spectd(P);
J1=P*map_mean(MAP)^2*map_scv(MAP); % autocovariance projectors
n=length(P);
for i=1:n
    for j=1:n
        J2(i,j)=pie*invD0*mP{i}*invD0*mP{j}*invD0*e(n);
    end
end

for i=1:n
    for j=1:n
        for k=1:n
            J3(i,j,k)=pie*invD0*mP{i}*invD0*mP{j}*invD0*mP{k}*invD0*e(n);
        end
    end
end

if ~issym(MAP{1})
    sP=sP(:)';
    J1(find(abs(J1)<10*eps))=0;
    J2(find(abs(J2)<10*eps))=0;
    J3(find(abs(J3)<10*eps))=0;
end
end