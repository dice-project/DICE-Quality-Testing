function MAP=map_super_tscales(MAPa,timescales)
MAP = MAPa;
MAPb = MAPa;
for ts=timescales(:)'
    MAPb{1} = MAPa{1} / ts;
    MAPb{2} = MAPa{2} / ts;    
    MAP = map_super(MAP,MAPb);
end
end