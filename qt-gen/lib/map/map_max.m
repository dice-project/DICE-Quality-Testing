function MAP = map_max(MAPa,MAPb)

D0a = MAPa{1};
D0b = MAPb{1};

D1a = MAPa{2};
D1b = MAPb{2};

na = length(D0a);
nb = length(D0b);

Ia = eye(na);
Ib = eye(nb);

Za = zeros(na);
Zb = zeros(nb);
Z = kron(Za,Zb);

M0=[
    krons(D0a,D0b),kron(D1a,Ib),kron(Ia,D1b);
    Z,kron(Ia,D0b),Z;
    Z,Z,kron(D0a,Ib);
];

M1=[
    Z,Z,Z;
    kron(Ia,D1b),Z,Z;
    kron(D1a,Ib),Z,Z;
];

MAP={M0,M1};

% piea = map_pie(MAPa);
% pieb = map_pie(MAPb);
% piea = [piea,0];
% pieb = [pieb,0];
% alpha = kron(piea,pieb);
% 
% D0a = [D0a, zeros(na,1); zeros(1,na+1)];
% D0a(1:na,end) = -D0a(1:na,1:na) * e(na);
% 
% D0b = [D0b, zeros(nb,1); zeros(1,nb+1)];
% D0b(1:nb,end) = -D0b(1:nb,1:nb) * e(nb);
% 
% D0 = krons(D0a,D0b);
% D0 = D0(1:end-1,1:end-1);
% alpha = alpha(1:end-1);
% D1 = (-D0) * e(length(alpha)) * alpha;
% 
% MAP = map_normalize({D0,D1});

end