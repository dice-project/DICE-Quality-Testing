function BiCov=map_bicov(MAP,BiCovLags)
BiCov=[];
for i=1:size(BiCovLags,1)
    if ~mod(i,100)
        i
    end
    BiCov(i)=map_joint(MAP,BiCovLags(i,:),[1,1,1]);
end
end