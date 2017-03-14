function IDIk=mmpp2_symidi(k)
r1=sym('q12');
r2=sym('q21');
l1=sym('mu11');
l2=sym('mu22');
IDIk=1+(2*r1*r2*(l1-l2)^2/((r1*l2+r2*l1)*(r1+r2)^2))*(1-(l1*l2/(l1*r2+l2*r1))/k*(1-(l1*l2/(l1*l2+r1*l2+r2*l1))^k));
end