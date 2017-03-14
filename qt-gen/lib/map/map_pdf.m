function f=map_pdf(MAP,tset)
pie=map_pie(MAP);
if issym(MAP{1}(1,1))
f=sym([]);
    e=sym(ones(length(MAP{1}),1));
else
e=ones(length(MAP{1}),1);
f=[];
end
e=ones(length(MAP{2}),1);
for t=tset    
    f(end+1)=pie*(expm(MAP{1}*t)*(-MAP{1}))*e;
end
end

