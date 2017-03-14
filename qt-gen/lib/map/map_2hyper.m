function [lambda,p]=map2hyper(MAP)
[theta,M]=spectd(-inv(MAP{1}));
pie=map_pie(MAP);
n = length(theta);
for i=1:n
    p(i)=pie*M{i}*e(n);
end
lambda = 1./theta;
end

function PROB=ctmc_solve(Q,options)
% PROB=ctmc_solve(P) - Equilibrium distribution of the continuous-time
% Markov chain
%
%  Input:
%  P: infinitesimal generator of the continuous-time Markov chain
%
%  Output:
%  PROB: equilibrium distribution of the continuous-time Markov chain
%
%  Examples:
%  - ctmc_solve([-0.5,0.5;0.2,-0.2])
%
% MAP Queueing Networks Toolbox
% Version 1.0 	 15-Apr-2008
Qsav=Q;
zerocol=find(sum(abs(Q))==0);
if length(zerocol)>1
    warning('ctmc_solve: the infinitesimal generator is reducible');
    b=zeros(size(Q,1),1);
elseif length(zerocol)==0
    zerocol=size(Q,1);
end
b=zeros(size(Q,1),1); b(zerocol)=1;
Q(:,zerocol)=1; % add normalization condition

p=(Q')\b; % compute steady state probability vector
%p=bicgstab(Q',b); % compute steady state probability vector
PROB=p'; % p is a row vector
end

function PIQ=map_prob(MAP)
% PIQ=map_prob(MAP) - Equilibrium distribution of the underlying
% continuous-time process
%
%  Input:
%  MAP: a MAP in the form of {D0,D1}
%
%  Output:
%  PIQ: equilibrium distribution of the continuous-time Markov chain
%  Q=D0+D1
%
% MAP Queueing Networks Toolbox
% Version 1.0 	 15-Apr-2008
PIQ=ctmc_solve(MAP{1}+MAP{2});
end


function PIE=map_pie(MAP)
% PIE=map_pie(MAP) - Equilibrium distribution of the embedded
% discrete-time process
%
%  Input:
%  MAP: a MAP in the form of {D0,D1}
%
%  Output:
%  PIE: equilibrium distribution of the discrete-time Markov chain embedded
%  at departure instants P=map_embedded(MAP)=((-D0)^-1)*D1
%
% MAP Queueing Networks Toolbox
% Version 1.0 	 15-Apr-2008
%
A=map_prob(MAP)*MAP{2};
PIE=A/(A*e(length(MAP{2})));
end

function [spectrum,projectors,nihil,V,D]=spectd(A,OPT)
% [spectrum,projectors,nihil,V,D]=spectd(A,OPT)
if nargin<2
    JORDAN=0;
elseif strcmpi(OPT,'jordan')
    JORDAN=1;
else
    JORDAN=0;
end
if JORDAN
    [V,J]=jordan(A);
    iV=inv(V);
    n=length(A);
    from=1;
    if issym(A(1,1))
        spectrum=sym([]);
        projectors=sym({});
        nihil=sym({});
    else
        spectrum=[];
        projectors={};
        nihil={};
    end
    for to=1:n
        if to==n || J(to,to+1)==0 % next is new block
            spectrum(end+1)=J(from,from);
            projectors{end+1}=V*subblock(eye(n),from,to)*iV;
            nihil{end+1}=V*subblock(diag(ones(1,n-1),1),from,to)*iV;
            from=to+1;
        end
    end
    D=J;
else
    if ~strcmpi(class(A(1,1)),'sym')
        if ~issparse(A)
            [V,D]=eig(A);
        else
            [V,D]=eigs(A);
        end
        spectrum=diag(D);
        projectors={};
    else
        [V,D]=eig(A);
        spectrum=diag(D);
        projectors={};
        i=1:length(A);
    end
    i=1:length(A);
    spectrum=spectrum(i);
    iV=inv(V);
    for k=i(:)'
        projectors{end+1}=V(:,k)*iV(k,:);
    end
    nihil={};
end
spectrum=reshape(spectrum,1,length(spectrum));

    function X=subblock(X,from,to)
        X(1:(from-1),:)=0;
        X(:,1:(from-1))=0;
        X((to+1):end,:)=0;
        X(:,(to+1):end)=0;
    end

end

function n=e(t)
if nargin<1
    n=[1;1];
else
    if iscell(t)
        n=ones(length(t{1}),1);
    else
    n=ones(t,1);    
    end
end
end