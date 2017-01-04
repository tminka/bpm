function z = predict(obj, X)
% p(y = 1 | X, D) = phi(z)
% WARNING: EP must have converged for this to be valid.
% Does not work for ADF.

if obj.add_bias
  X = [X ones(rows(X), 1)];
end

if isempty(obj.kernel)
  z = X*obj.mw;
  xvwx = sum((X*obj.vw).*X,2);
else
  K = feval(obj.kernel, X, obj.X, obj.kernel_args{:});
  K = scale_cols(K, obj.Y);
  z = K*obj.alpha;
  Kv = scale_cols(K, 1./obj.state.v);
  if 1
    xvwx = -sum(Kv.*K,2) + sum((Kv*obj.state.A).*Kv,2);
  else
    iv = 1./obj.state.v;
    Q = diag(iv) - scale_rows(scale_cols(obj.state.A,iv),iv);
    xvwx = -sum((K*Q).*K,2);
  end
  xvwx = xvwx + feval(obj.kernel, X, 'diag', obj.kernel_args{:});

  if 0
    d = cols(X);
    Xv = scale_rows(obj.X, 1./obj.state.v);
    obj.vw = inv(eye(d) + obj.X'*Xv);
    obj.vw
    xvwx = diag(X*obj.vw*X')
  end
end
z = z./sqrt(xvwx);
