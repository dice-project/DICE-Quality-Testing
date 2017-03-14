function [MAP]=map_randacf(K,level)
isok=0;
while ~isok
D1=rand(K,K);
D0=rand(K,K);
for i=1:K
    D1a=zeros(K);
    D1a(i,:)=(10^(level*i))*sprand(1,K,1/K);
    D1=D1+D1a;
end

MAP=cell(1,2);
MAP{1}=D0;
MAP{2}=D1;
MAP=map_normalize(MAP);
%if map_acf(MAP,1)>0.1
    isok=1;

%end
end
end


