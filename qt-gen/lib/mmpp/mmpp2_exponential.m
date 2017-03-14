function MMPP2=mmpp2_exponential(MEAN)
muM=1/MEAN;
MMPP2=cell(1,2);
    
MMPP2{1}=[-1e-8-muM,1e-8;1e-8,-muM-1e-8];
MMPP2{2}=diag([muM,muM]);
end