function [MMPP]=mmpp_sym(K)
MMPP=map_sym(K);
MMPP{2}=diag(diag(MMPP{2}));
MMPP=map_normalize(MMPP);
end


