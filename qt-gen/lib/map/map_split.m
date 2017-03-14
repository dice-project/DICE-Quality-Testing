function MAP=map_split(MAP,r)
% probabilistic splitting
MAP={map_infgen(MAP)-r*MAP{2},r*MAP{2}};
end