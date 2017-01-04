function [obj,run] = train_ard_kernel(obj, X, Y, fiv)
% must specify X and Y separately
% specify fiv to continue a previous run

if ~strcmp(obj.kernel, 'linear')
  error('kernel must be linear')
end

if obj.add_bias
  X = [X ones(rows(X),1)];
end
X2 = X.*X;

[n,d] = size(X);
first_fiv = 1;
if nargin < 4
  fiv = first_fiv*ones(1,d);
end  

for iter = 1:10
  old_fiv = fiv;
  
  s = 1./sqrt(fiv);
  obj.add_bias = 0;
  x = scale_cols(X, s);
  obj = train(obj, x, Y);
  obj.add_bias = 1;

  obj.mw = ((obj.alpha.*Y)'*X).*s.*s;
  if 0
    Xv = scale_rows(X, 1./obj.state.v);
    obj.vw = inv(diag(s.^(-2)) + X'*Xv);
    obj.vw
    dvw = 1 - sum(Xv.*X, 1) + sum((obj.state.A*Xv).*Xv,1);
    dvw = dvw';
  else
    if 0
      xv = scale_rows(x, 1./obj.state.v);
      obj.vw = inv(eye(d) + x'*xv);
      obj.vw = scale_rows(scale_cols(obj.vw,s),s);
      dvw = diag(obj.vw)';
    elseif 0
      x = scale_rows(x, Y);
      %C = x*x';
      %dv = diag(obj.state.v);
      %A = dv - dv*inv(C + dv)*dv
      xv = scale_rows(x, 1./obj.state.v);
      dvw = 1 - sum(xv.*x, 1) + sum((obj.state.A*xv).*xv,1);
      dvw = dvw.*s.*s;
    else
      iv = 1./obj.state.v;
      vAv = scale_rows(scale_cols(obj.state.A,iv.*Y'),iv.*Y');
      dvw = 1 - (iv*X2).*s.*s + sum((vAv*X).*X,1).*s.*s;
      dvw = dvw.*s.*s;
    end
  end
  
  % update fiv
  % fast EM
  fiv = sqrt(fiv./(obj.mw.^2).*(1 - fiv.*dvw));
  if obj.add_bias
    % don't shrink the bias
    fiv(end) = first_fiv;
  end
  % avoid numerical overflow
  i = find(old_fiv > 1e6);
  fiv(i) = inf;
  
  run.fiv(iter,:) = fiv;
  run.mw(iter,:) = obj.mw;
  run.loo(iter) = obj.loo;
  run.loo_count(iter) = obj.loo_count;
  run.train_err(iter) = obj.train_err;
  run.stability(iter) = obj.stability;
  run.s(iter) = obj.s;
  
  fprintf('iter %d: train_err = %g, loo = %g\n', iter, obj.train_err, obj.loo)
end

% how to make alpha reflect scaled mw?
%obj.alpha = scale_rows(X,Y)\obj.mw;

obj.X = X;
obj.Y = Y;

