function K = kernelmtx_linear(X,Y)
% KERNELMTX(X,Y) returns a matrix of inner products.
% X and Y are matrices of data vectors (rows).
% KERNELMTX(X,'diag') returns the inner product of each row with itself,
% i.e. diag(kernelmtx(X,X)).
% Don't forget to add a bias to the data first!

if ~ischar(Y)
  K = X*Y';
else
  K = sum(X.*X,2);
end
