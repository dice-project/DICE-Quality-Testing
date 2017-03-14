function MAP=map_erlangswitchify(MAP,k)
% makes hidden transitions erlang k
n= size(MAP{1},1);
if n>2
 error('script works only for map2');
end
D0=MAP{1};
D1=MAP{2};
h12 = D0(1,2)*k;
h21 = D0(2,1)*k;
o11 = D1(1,1);
o12 = D1(1,2);
o21 = D1(2,1);
o22 = D1(2,2);
A0 = zeros(2*k);
A1 = zeros(2*k);
for i=1:k
 A0(i,i+1)=h12;
 A1(i,i)=o11;
 A1(i,k+1)=o12;
end
for i=(k+1):2*k
 if i<2*k
 A0(i,i+1)=h21;
 else
 A0(i,1)=h21;
 end
 A1(i,i)=o22;
 A1(i,1)=o21;
end
MAP = map_normalize({A0,A1});
end
