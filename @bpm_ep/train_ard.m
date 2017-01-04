function [obj,run] = train_ard(obj, X, Y, varargin)
% type should be probit

if ~isempty(obj.kernel)
  [obj,run] = train_ard_kernel(obj, X, Y, varargin{:});
  return
end

if nargin > 2
  if obj.add_bias
    X = [X ones(rows(X),1)];
  end
  X = scale_rows(X,Y);
end
[n,d] = size(X);
if isempty(varargin)
  fiv = 1e-4*ones(d,1);
else
  fiv = varargin{1};
end

obj.state = [];

for iter = 1:1
  old_fiv = fiv;
  if 1
    obj.vp = diag(1./fiv);
    obj = retrain(obj, X);
  else
    s = 1./sqrt(fiv);
    x = scale_cols(X, s);
    %x = scale_cols(X, sqrt(1./fiv));
    obj = train(obj, x);
    obj.mw = obj.mw.*s;
    obj.vw = scale_rows(scale_cols(obj.vw,s),s);
  end
  if 0
    obj.s
    obj.mw
    obj.vw
  end
  
  % update fiv
  dvw = diag(obj.vw)
  % slow EM
  %fiv = 1./(obj.mw.^2 + dvw);
  % fast EM
  fiv = sqrt(fiv./(obj.mw.^2).*(1 - fiv.*dvw));
  if obj.add_bias
    % don't shrink the bias
    fiv(end) = 1e-4;
  end
  
  run.fiv(iter,:) = fiv;
  run.mw(iter,:) = obj.mw;
  run.s(iter) = obj.s;
  run.margin(iter) = min(abs(X*obj.mw));
  run.loo(iter) = obj.loo;
  run.stab(iter) = obj.stability;
end
