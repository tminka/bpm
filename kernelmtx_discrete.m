function K = kernelmtx_discrete(X,Y,p)
% KERNELMTX(X,Y) returns a matrix of inner products.
% X and Y are matrices of data vectors (rows).
% KERNELMTX(X,'diag') returns the inner product of each row with itself,
% i.e. diag(kernelmtx(X,X)).

if ~ischar(Y)
  nx = rows(X);
  ny = rows(Y);
  K = ones(nx,ny);
  for j = 1:cols(X)
    if rem(j,1000) == 0
      disp(j)
    end
    % z is nx by ny equality matrix for attribute j
    z = (repmat(X(:,j), 1, ny) == repmat(Y(:,j)', nx, 1));
    K = K .* (1 + p*z)/(1+p);
  end
else
  K = ones(rows(X),1);
end
