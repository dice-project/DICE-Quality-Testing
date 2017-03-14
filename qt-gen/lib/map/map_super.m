function MAP=map_super(MAPa,MAPb)
if nargin==1
    MAPb=2;
end
if length(MAPb)==1
    MAP=MAPa;
    for it=1:MAPb-1
        D0s=krons(MAP{1},MAPa{1});
        D1s=krons(MAP{2},MAPa{2});
        MAP={D0s,D1s};
        MAP=map_normalize(MAP);
    end
else
    D0s=krons(MAPa{1},MAPb{1});
    D1s=krons(MAPa{2},MAPb{2});
    MAP={D0s,D1s};
    MAP=map_normalize(MAP);
end