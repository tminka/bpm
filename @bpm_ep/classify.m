function [Y,z] = classify(obj, X)
% WARNING: EP must have converged for this to be valid.
% Does not work for ADF.

if isempty(obj.kernel)
  if obj.add_bias
    z = X*obj.mw(1:end-1) + obj.mw(end);
  else
    z = X*obj.mw;
  end
else
  if obj.add_bias
    X = [X ones(rows(X), 1)];
  end
  K = feval(obj.kernel, X, obj.X, obj.kernel_args{:});
  z = K*(obj.Y.*obj.alpha);
end
Y = sign(z);
