function MAP=map_hbal()
syms p l1 l2 real;
MAP=map_symblock(2);
MAP{2}=symeval(MAP{2},'p21=p','p12=p','q11=1/l1','q22=1/l2');
MAP=map_normalize(MAP);
end