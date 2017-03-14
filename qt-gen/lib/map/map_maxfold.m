function MAP = map_maxfold(MAPa,MAPb)
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

la = D1a*e(na); % departure rates from A's states
pie = map_pie(MAPa);
laf = [];
pieb = map_pie(MAPb);
for i=1:na
    laf(i) = 1/(1/la(i) + (pieb * la(i) * inv( -MAPb{1} ) * inv( la(i)*Ib - MAPb{1} ) * e(nb)));
end
D = D0a + diag(la) - diag(laf);
MAP = {D, -D*e(na)*pie};
end