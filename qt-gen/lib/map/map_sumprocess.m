function SMAP=map_sumprocess(MAP,n)
% MAP_SUMPROCESS - MAP of S=S_1+S_2+..+S_n where S_i are identically
% distributed samples drawn from the same MAP
D0=MAP{1}; D1=MAP{2}; Z=0*D0;
K=length(D0);
SMAP0=zeros(K*n);
SMAP1=zeros(K*n);
for i=1:(n-1)
    SMAP0(((i-1)*K+1):i*K,((i-1)*K+1):i*K)=D0;
    SMAP0(((i-1)*K+1):i*K,(i*K+1):(i+1)*K)=D1;    
end
SMAP0(((n-1)*K+1):n*K,((n-1)*K+1):n*K)=D0;    
SMAP1(((n-1)*K+1):n*K,1:K)=D1;    
SMAP={SMAP0,SMAP1};
end
