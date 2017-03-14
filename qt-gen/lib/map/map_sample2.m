function [SAM,laststate]=map_sample2(MAP,nSamples,initState)
nStates=length(MAP{1});
if nargin<3
    initState=randi(1,1,[1 nStates]);
end

for b=0:1
    for i=1:nStates
        for j=1:nStates
            p(i,b*nStates+j)=MAP{b+1}(i,j)/abs(MAP{1}(i,i));
        end
    end
end
for i=1:nStates
    p(i,i)=0;
end
cdf=0*p;
for i=1:nStates
    cdf(i,:)=cumsum(p(i,:));
end
cdf=abs(cdf);
curState=initState;
visits=zeros(nSamples,20);
maxpathlen=size(visits,2);
for i=1:nSamples
    arrival=0;
    last=2;
    visits(i,1)=curState;
    while ~arrival
        destState=find(cdf(curState,:)>=rand,1,'first');
        if destState>nStates
            arrival=1;
            destState=destState-nStates;         
            curState=destState;
        else
            visits(i,last)=destState;
            curState=destState;
            last=last+1;
        end
        if last>maxpathlen
            maxpathlen=maxpathlen+5;
            visits(:,end+5)=0;
        end
    end
end
holdTimes=-1./diag(MAP{1});
H=visits;
for i=1:nSamples
   laststate(i)=visits(i,max(find(visits(i,:))));
end
for i=1:nStates
    H(find(visits==i))=holdTimes(i);
end
SAM=0*H(:,1);
for i=1:size(H,2)
  for j=1:size(H,1)
    if H(j,i)>0
    SAM(j)=SAM(j)+exprnd(H(j,i));
    end
  end
end
SAM=SAM(1:nSamples);
end