function MAP=map_indepfit(pie,D0,A,Alags)
%% number of variables
n = length(pie);
%% initial point
x0 = reshape(rand(n),n^2,1); % state variable is P matrix
iD0 = inv(-D0);
%% optimization
MAXITER=100;
MAXCHECKITER=1000;
TOL=1e-8;
EPSTOL=100*TOL;
options=optimset( 'Display','iter', 'LargeScale','off','MaxIter',MAXITER, 'MaxFunEvals',1e10, ...
    'MaxSQPIter',500, 'TolCon',TOL, 'Algorithm', 'active-set');
T0 = tic; % needed for outfun
%% optimization program
[xopt, f]=fmincon(@objfun,x0,[],[],[],[],x0*0+EPSTOL,x0*1000,@nnlcon,options);
D1 = topar(xopt);
MAP = map_normalize({D0,D1});
    function D1 = topar(x)
        D1 = reshape(x(1:n^2),n,n);
    end

    function [c,ceq]=nnlcon(x)
        c   = [];
        ceq = [];
        
        D1 = topar(x);        
        ceq(end+(1:n),1) = reshape(D1 * e(n) + D0 * e(n),1,n);
        ceq(end+(1:n),1) = pie * iD0 * D1 - pie;
    end

    function f = objfun(x)
        D1 = topar(x);
        MAP = map_normalize({D0,D1});
        f = norm(map_acf(MAP,Alags)-A');
    end

    function stop = outfun(x, optimValues, state)
        global MAXTIME;
        
        stop = false;
        if strcmpi(state,'iter')
            if mod(optimValues.iteration,MAXCHECKITER)==0 && optimValues.iteration>1
                reply = input('Do you want more? Y/N [Y]: ', 's');
                if isempty(reply)
                    reply = 'Y';
                end
                if strcmpi(reply,'N')
                    stop=true;
                end
            end
            if toc(T0)>MAXTIME
                fprintf('Time limit reached. Aborting.\n');
                stop = true;
            end
        end
    end
end