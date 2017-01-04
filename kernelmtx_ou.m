function K = kernelmtx_ou(X,Y,sigma)
% KERNELMTX(X,Y) returns a matrix of inner products.
% X and Y are matrices of data vectors (rows).
% KERNELMTX(X,'diag') returns the inner product of each row with itself,
% i.e. diag(kernelmtx(X,X)).

if ~ischar(Y)
	K = exp(-sqrt(sqdist(X',Y'))/sigma);
else
  K = ones(rows(X),1);
end
