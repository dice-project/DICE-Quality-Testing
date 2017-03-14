function MAP=map_modulatemaps(MAPs,P)
n=length(MAPs);
if length(P)~=n
    error('map_modulatemaps: P order must equal number of MAPs')
end
l=[];
for i=1:n
    l(i)=length(MAPs{i}{1});
end
D0=(zeros(sum(l)));
D1=D0;

currow=0;
for i=1:n
    D0((currow+1):(currow+l(i)),(currow+1):(currow+l(i))) = MAPs{i}{1};
    curcol = 0;    
    for j=1:n
        D1((currow+1):(currow+l(i)),(curcol+1):(curcol+l(j))) = P(i,j)*MAPs{i}{2}*e(l(i))*map_pie(MAPs{j});
        curcol = curcol + l(j);
    end
    currow = currow + l(i);
end
MAP={D0,D1};

end