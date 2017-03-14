function h2=map_h2(MAP)
e1=map_e1(MAP);
e2=map_e2(MAP);
e3=map_e3(MAP);
r1=e1;
r2=e2/2;
r3=e3/6;
h2=(r2/r1^2-1);
end