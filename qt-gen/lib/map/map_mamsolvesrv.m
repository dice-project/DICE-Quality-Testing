function [p,util,caudal,R]=map_mamsolvesrv(MAP,util)
convertMAMS(map_exponential(1),map_scale(MAP,util),1e-8,'test');
p=textread('QL-dist');
util=1-p(1);
p=p(2:end,2);
R=textread('R-matrix');
caudal=max(eig(R));
delete drift-conditions;
delete R-matrix;
delete G-matrix;
delete probability;
delete QL-dist;
%delete Ql-length;
end


function convertMAMS(MAP_A,MAP_S,p,filename)
% This function is used to convert the MAP/MAP/1 queue into
% an input file for MAMSolve
% Note: for QBD only
% p is precision

fid = fopen(filename,'w');
a = size(MAP_A{1},1);
s = size(MAP_S{1},1);
bulk = 1;
fprintf(fid,'%d\n %d\n %d\n',a*s,a*s,bulk);
fprintf(fid,'%30.15f\n',p);
Q = MAP_inputQBD(MAP_A,MAP_S);
Lhat = Q{1};
Fhat = Q{2};
Bhat = Q{3};
L = Q{4};
F = Q{5};
B = Q{6};
printMatrix(Lhat,fid);
printMatrix(Bhat,fid);
printMatrix(Fhat,fid);
printMatrix(B,fid);
printMatrix(L,fid);
printMatrix(F,fid);
fclose(fid);

movefile(filename,'/home/f85/casale/smirnigrp/experiments/MAMSolver/','f');
system(sprintf('cat /home/f85/casale/smirnigrp/experiments/MAMSolver/%s | /home/f85/casale/smirnigrp/experiments/MAMSolver/MAMSolve 0 1',filename));
    function printMatrix(M,fid)
        % This function is for printing squared matrix
        fprintf(fid,'\n');
        dim = size(M,1);
        for i = 1:dim
            for j = 1:dim
                fprintf(fid,'\t%20.9f',M(i,j));
            end
            fprintf(fid,'\n');
        end

    end


end

function Q = MAP_inputQBD(MAP_A,MAP_S)

dimA = size(MAP_A{1},1);
dimS = size(MAP_S{1},1);

IA = eye(dimA,dimA);
IS = eye(dimS,dimS);

Lhat = kron(MAP_A{1},IS);      % Lhat for interaction among boundary states
Bhat = kron(IA,MAP_S{2});      % Bhat for interaction between first level states and boundary states
Fhat = kron(MAP_A{2},IS);      % Fhat for interaction between boundary states and first level states

B = kron(IA,MAP_S{2});         % B for inter level backward transition
L = Lhat + kron(IA,MAP_S{1});  % L for within-level transitions
F = kron(MAP_A{2},IS);         % F for inter level forward transitions

Q = {Lhat, Fhat, Bhat,L,F,B};

end
