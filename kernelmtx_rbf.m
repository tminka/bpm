function K = kernelmtx_rbf(X,Y,sigma)
% KERNELMTX(X,Y) returns a matrix of inner products.
% X and Y are matrices of data vectors (rows).
% KERNELMTX(X,'diag') returns the inner product of each row with itself,
% i.e. diag(kernelmtx(X,X)).

if ~ischar(Y)
  %X2 = repmat(sum(X.^2,2), 1, rows(Y));
  %Y2 = repmat(sum(Y.^2,2), 1, rows(X));
  %K = X2+Y2'-2*X*Y';
  K = exp(-sqdist(X',Y')/(2*sigma^2));
else
  K = ones(rows(X),1);
end
