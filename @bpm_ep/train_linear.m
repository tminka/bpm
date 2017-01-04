function obj = train_linear(obj, x)
% x is a matrix of columns
% e is the label error rate
% s is the log evidence
% m is the posterior mean
% v is the posterior variance
% Output:
% obj.s
% obj.mw
% obj.vw
% obj.state

show_progress = 1;
% restrict = 1 prevents v(i) < 0
restrict = obj.restrict;

e = obj.e;
type = obj.type;

[d,n] = size(x);

if isempty(obj.mp)
  mp = zeros(d,1);
else
  mp = obj.mp;
end
if isempty(obj.vp)
  vp = eye(d);
else
  vp = obj.vp;
end

if isempty(obj.state)
  % a(i) is scale for term i
  % m(i) is x(:,i)'*m(:,i)
  % v(i) is variance for term i
  a = zeros(1,n);
  m = ones(1,n);
  % this makes the first pass equal to ADF
  v = ones(1,n)*Inf;

  % posterior
  vw = vp;
  mw = mp;
else
  a = obj.state.a;
  m = obj.state.m;
  v = obj.state.v;
  
  % compute (mw,vw) using (5.58,5.59)
  xv = scale_cols(x, 1./v);
  vw = inv(inv(vp) + xv*x');
  mw = vw*(x*(m./v)');
end

niters = 200;
last = 0;
for iter = 1:niters
  last = last | (iter == niters);
  nskip = 0;
  old_mw = mw;
	old_v = v;
  for i = 1:n
    vwx = vw*x(:,i);
    xvwx = x(:,i)'*vwx;
    if isfinite(v(i))
      v0 = vw + vwx*inv(v(i) - xvwx)*vwx';
      v0x = vwx*(v(i)/(v(i) - xvwx));
      xv0x = 1/(1/xvwx - 1/v(i));
      m0 = mw + v0x/v(i)*(x(:,i)'*mw - m(i));
    else
      v0 = vw;
      v0x = vwx;
      xv0x = xvwx;
      m0 = mw;
    end
    if xv0x < 0
      %error('xv0x < 0.  data not separable or need to restrict.')
      %fprintf('skipping point %d on iter %d\n', i, iter)
      nskip = nskip + 1;
      continue
    end

    xm = x(:,i)'*m0;
    if strcmp(type, 'probit')
      z = xm/sqrt(xv0x + e^2);
      true = normcdfln(z);
      % this is actually alpha/e
      alpha = exp(mvnormpdfln(z,0,1) - true)/sqrt(xv0x + e^2);
    else
      z = xm/sqrt(xv0x);
      if e == 0
				true = normcdfln(z);
				alpha = exp(mvnormpdfln(z,0,1) - true)/sqrt(xv0x);
      else
				true = e + (1-2*e)*normcdf(z);
				alpha = (1-2*e)*mvnormpdf(z,0,1)/true/sqrt(xv0x);
				true = log(true);
      end
    end
    mw = m0 + v0x*alpha;
    xmw = x(:,i)'*mw;

    if isnan(z)
      error('z is nan')
    end
    if 1
      % generalization error estimates
      stability(i) = abs(xv0x);
      zi(i) = z;
    end
    
    prev_v = v(i);
    if alpha == 0
      v(i) = Inf;
    elseif strcmp(type, 'probit')
      % this is actually v(i)*e^2
      v(i) = (xv0x + e^2)/(alpha*(xmw+alpha*e)) - xv0x;
    else
      v(i) = xv0x*(1/(xmw*alpha) - 1);
    end
    if restrict & v(i) < 0
      % hack: skip the update if v(i) would be negative
      fprintf('restricting %d\n',i);
      v(i) = prev_v;
    else
      % only do this if we have changed v(i)
      if 0
				% incremental inverse of ivw
				delta = 1/v(i) - 1/prev_v;
				vw = vw - (vw*x(:,i))*(delta/(1 + xvwx*delta))*(x(:,i)'*vw);
      else
				% ADF update for vw
				if strcmp(type,'probit')
					vw = v0 - v0x*(alpha*(xmw+alpha*e)/(xv0x+e^2))*v0x';
				else
					vw = v0 - v0x*(alpha*xmw/xv0x)*v0x';
				end
      end
    end
    % in probit case, this is actually m(i)*e
    m(i) = xm + (xv0x + v(i))*alpha;

    % this part only needs to be done on the last iter
    if show_progress | last 
      % p = -0.5*(mi - m0)'*inv(Vi + V0)*(mi - m0)
      %p = -0.5*(m(i) - xm)^2*(x(:,i)'*mw)/xv0x*alpha;
      % identical to above
      if strcmp(type,'probit')
				p = -0.5*alpha*(xv0x+e^2)/(xmw+e*alpha);
      else
				p = -0.5*alpha*xv0x/xmw;
      end
      p = p - 0.5*log(1 + xv0x/v(i));
      a(i) = true - p;
    end
  end
  
  if nskip > 0
    fprintf('skipped %d points on iter %d\n',nskip,iter);
  end
  if show_progress
    s = mp'*inv(vp)*mp - mw'*inv(vw)*mw;
    for i = 1:n
      s = s + m(i)^2/v(i);
    end
    ev(iter) = 0.5*logdet(vw) - 1/2*s + sum(a) - 0.5*logdet(vp);
		ev(iter) = log(max(abs(1./v - 1./old_v)));
  end
  if show_progress & rem(iter,100) == 0
    if rows(x) == 3
      figure(1)
      delete(findobj(gcf,'tag','train_linear'))
      h = draw_line_clip(mw(1),mw(3),-mw(2),'r','tag','train_linear');
      drawnow
    end
  end
  if show_progress & rem(iter,100) == 0
    figure(2)
    plot(ev)
    drawnow
  end
  if show_progress & 0
    run.m(:,iter) = m;
    run.v(:,iter) = v;
    if rem(iter,100) == 0
      figure(1)
      plot(run.v')
      drawnow
    end
  end

  %if max(abs(m - old_m)) < 1e-4 & max(abs(v - old_v)) < 1e-4
  %  break
  %end
  if max(abs(mw - old_mw)) < 1e-8
    if last 
      break
    else
      last = 1;
    end
  end
  if e == 0 & min(v) < 1e-10
    error('data is not separable')
  end
end
if iter == niters
  warning('not enough iters')
else
  fprintf('EP converged in %d iterations\n',iter);
end

if show_progress
  figure(2)
  plot(ev)
end

s = mp'*inv(vp)*mp - mw'*inv(vw)*mw;
for i = 1:n
  s = s + m(i)^2/v(i);
end
s = 0.5*logdet(vw) - 1/2*s + sum(a) - 0.5*logdet(vp);

if 1
  % generalization error estimates
  obj.stability = mean(stability);
  obj.loo = exp(logsumexp(normcdfln(-25*zi),2))/n;
  obj.loo_count = mean(zi <= 0);
  obj.train_err = mean(mw'*x <= 0);
end

obj.s = s;
obj.mw = mw;
obj.vw = vw;
obj.state.a = a;
obj.state.m = m;
obj.state.v = v;
