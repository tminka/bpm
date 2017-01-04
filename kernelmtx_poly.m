function K = kernelmtx_poly(X,Y,p)
% KERNELMTX(X,Y) returns a matrix of inner products.
% X and Y are matrices of data vectors (rows).
% KERNELMTX(X,'diag') returns the inner product of each row with itself,
% i.e. diag(kernelmtx(X,X)).

if ~ischar(Y)
  K = (X*Y' + ones(rows(X),rows(Y))).^p;
else
  K = (sum(X.*X,2)+1).^p;
end
