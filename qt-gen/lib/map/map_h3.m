function h3=map_h3(MAP)
e1=map_e1(MAP);
e2=map_e2(MAP);
e3=map_e3(MAP);
r1=e1;
r2=e2/2;
r3=e3/6;
h3=(r3*r1-r2^2)/r1^4;
end