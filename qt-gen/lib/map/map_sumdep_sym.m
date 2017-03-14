function MAP=map_sumdep_sym(MAP,n)
for i=1:n
    MAPs{i}=MAP;
end
l=[];
for i=1:n
    l(i)=length(MAPs{i}{1});
end
D0=sym(zeros(sum(l)));
D1=D0;

curpos=0;
for i=1:n
    D0((curpos+1):(curpos+l(i)),(curpos+1):(curpos+l(i))) = MAPs{i}{1};
    if i<n
        D0((curpos+1):(curpos+l(i)),(curpos+l(i)+1):(curpos+l(i)+l(i+1))) = MAPs{i}{2};
    else
        D1((curpos+1):(curpos+l(i)),1:l(1)) = MAPs{i}{2};
    end
    curpos = curpos + l(i);
end
MAP={D0,D1};
end