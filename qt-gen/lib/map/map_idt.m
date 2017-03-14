function I=map_idt(MAP)

T=10.^(-6:6);
I=[];
for t=T
    I(end+1)=map_varcount(MAP,t)/map_lambda(MAP)/t;
end

end