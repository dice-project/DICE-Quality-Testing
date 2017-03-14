function E3=map_skewcount(MAP,t)
r1=MAP{1}(1,2);
r2=MAP{1}(2,1);
l1=MAP{2}(1,1);
l2=MAP{2}(2,2);
A11=(l1*r2+l2*r1)^3/(r1+r2)^2;
A21=2*r1*r2*(l1-l2)^2*(l1*r2+l2*r1)/(r1+r2)^3;
A31=r1*r2*(l1-l2)^2*(l1*r1+l2*r2-2*(l1*r2+l2*r1))/(r1+r2)^4;
A41=-2*r1*r2*(l1-l2)^3*(r1-r2)/(r1+r2)^5;
A12=r1*r2*(l1-l2)^2*(l1*r1+l2*r2)/(r1+r2)^4;
Nt=t*(l1*r2+l2*r1)/(r1+r2);
g3=(6/(r1+r2))*(A11*t^3/6+A21*t^2/2+A31*t+A12*t*exp(-(r1+r2)*t)+A41*(1-exp(-(r1+r2)*t)));
It=1+2*(l1-l2)^2*r1*r2/(r1+r2)^2/(l1*r2+l2*r1)-2*(l1-l2)^2*r1*r2*(1-exp(-(r1+r2)*t))/(r1+r2)^3/(l1*r2+l2*r1)/t; % OK
E3=g3-Nt^3-3*Nt*(Nt-1)*It-Nt*(Nt-1)*(Nt-2);
end