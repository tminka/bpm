function obj = train_kernel(obj, C)
% C is the n by n kernel matrix, prescaled by Y.
% e is the label error rate.
% s is the evidence.
% alpha is the sample weighting vector for classification.
% run gives information about the run.

e = obj.e;
type = obj.type;
restrict = obj.restrict;

n = rows(C);

% train_kernel cannot be restarted from previous run 
% (too expensive to compute A)

% a(i) is scale for term i
% m(i) is x(:,i)'*m(:,i)
% v(i) is variance for term i
a = zeros(1,n);
m = ones(1,n);
% this makes the first pass equal to ADF
% using inf here makes restriction fail
v = ones(1,n)*Inf;

% alpha represents the final mw,vw
alpha = zeros(1,n);
% h(i) is xmw
h = zeros(1,n);
% lambda(i) is xv0x
lambda = diag(C);
A = C;

niters = 40;
%niters = 1;
for iter = 1:niters
  %fprintf('EP iter %g\n', iter);
  old_m = m;
  old_v = v;
  old_alpha = alpha;
  for i = 1:n
    h(i) = (m./v)*A(:,i);
    if isfinite(v(i))
      lambda(i) = 1/(1/A(i,i) - 1/v(i));
      h0 = h(i) + lambda(i)/v(i)*(h(i) - m(i));
    else
      lambda(i) = A(i,i);
      h0 = h(i);
    end
    if A(i,i) == 0
      error(sprintf('A(%d,%d) = 0.  Remove all-zero data points.', i,i))
    end
    if lambda(i) < 0
      error(sprintf('lambda(%d) < 0',i))
    end

    if strcmp(type,'probit')
      z = h0/sqrt(lambda(i)+e^2);
      % logcdf is expensive, so reuse it
      true = normcdfln(z);
      % this is actually alpha/e
      alpha(i) = exp(mvnormpdfln(z,0,1) - true)/sqrt(lambda(i) + e^2);
    else
      z = h0/sqrt(lambda(i));
      if e == 0
	% logcdf is expensive, so reuse it
	true = normcdfln(z);
	alpha(i) = exp(mvnormpdfln(z,0,1) - true)/sqrt(lambda(i));
      else
	true = e + (1-2*e)*normcdf(z);
	alpha(i) = (1-2*e)*mvnormpdf(z,0,1)/true/sqrt(lambda(i));
	true = log(true);
      end
    end
    if isnan(z)
      error('z is nan')
    end
    if 1
      % generalization error estimates
      stability(i) = abs(lambda(i)*alpha(i));
      zi(i) = z;
    end
    h(i) = h0 + lambda(i)*alpha(i);

    if alpha(i) == 0
      v(i) = inf;
    elseif strcmp(type, 'probit')
      % this is actually v(i)*e^2
      v(i) = (lambda(i) + e^2)/(alpha(i)*(h(i)+alpha(i)*e)) - lambda(i);
    else
      v(i) = lambda(i)*(1/(alpha(i)*h(i)) - 1);
    end
    if restrict & v(i) < 0
      % hack: skip the update if v(i) would be negative
      fprintf('restricting %d\n',i);
      v(i) = old_v(i);
    end
    if isfinite(v(i))
      m(i) = h(i) + v(i)*alpha(i);
    else
      m(i) = 0;
    end
    if strcmp(type,'probit')
      a(i) = 0.5*alpha(i)*(lambda(i)+e^2)/(h(i)+e*alpha(i));
    else
      a(i) = 0.5*alpha(i)*lambda(i)/h(i);
    end
    a(i) = a(i) + true + 0.5*log(1+lambda(i)/v(i));
  
    if 1/v(i) ~= 1/old_v(i)
      delta = 1/(1/v(i) - 1/old_v(i));
      A = A - A(:,i)*(A(i,:)/(delta + A(i,i)));
      %dv = diag(v);
      %A = dv - dv*inv(C + dv)*dv;
      %A = inv(inv(C) + inv(dv));
    end
  end
  
  %if max(abs(m - old_m)) < 1e-6
  if max(abs(alpha - old_alpha)) < 1e-4
    break
  end
  if e == 0 & min(v) < 1e-10
    error('data is not separable')
  end
end
if iter == niters
  disp('not enough iters')
else
  fprintf('EP converged in %d iterations\n',iter);
end

s = m./v;
s = s*A*s' - sum(m.^2./v);
s = s/2 + sum(a);
if any(v < 0)
  warning('some v(i) < 0')
  %s = s + 0.5*logdet(A) - 0.5*logdet(C);
else
  % equivalent to the above, but faster
  dv = diag(v);
  s = s + 0.5*sum(log(v)) - 0.5*logdet(C + dv);
end

if 1
  % generalization error estimates
  obj.stability = mean(stability);
  obj.loo = exp(logsumexp(normcdfln(-25*zi),2))/n;
  obj.loo_count = mean(zi <= 0);
  % need to update h first
  %h = (m./v)*A;
  obj.train_err = mean(h <= 0);
end

obj.s = s;
obj.alpha = alpha';
obj.state.A = A;
obj.state.m = m;
obj.state.v = v;
