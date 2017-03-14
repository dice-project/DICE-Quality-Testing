function sqsd=map_power(MAP,fset)
n=length(MAP{1});
sqsd=[];
for f=fset
sqsd(end+1)=map_piq(MAP)*MAP{2}*inv(4*pi^2*f^2*eye(n)+(MAP{1}-MAP{2})^2)*e(n);
end
end