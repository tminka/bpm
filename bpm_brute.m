function [s,m,v] = bpm_brute(task, nsamples, fun, varargin)
% BPM_BRUTE      Compute moments of version space by brute force.
%
% [s,m,v] = BPM_BRUTE(task,nsamples) returns
% s   volume of version space (in log domain)
% m   mean vector 
% v   covariance matrix
% estimated by Monte Carlo on nsamples samples.
%
% Algorithm: uniformly sample the sphere and weight solutions
% by their likelihood.

% written by Tom Minka

if nargin < 3
  fun = @bpm_likelihood;
end
if ~isempty(task.kernel)
  error('kernel unsupported')
end
e = task.e;
x = task.data;
[n,d] = size(x);
groupsize = 1000;
total = zeros(d,1);
total2 = zeros(d);
total_ok = 0;
total_sampled = 0;

while(nsamples > 0)
  howmany = min([nsamples groupsize]);
  %disp(['sampling ' num2str(howmany)])
  % sample from N(0,I)
  ws = randn(d, howmany);
  % sample from Laplace(0,I)
  %ws = exprnd(1, 2*d, howmany);
  %ws = ws(1:d, :) - ws(d+(1:d), :);
  nsamples = nsamples - howmany;
  total_sampled = total_sampled + howmany;

  if 1
    p = feval(fun,task,ws,varargin{:});
  else
    % this part is the same as bpm_likelihood
    if strcmp(task.type, 'step')
      if e == 0
				p = all(x*ws > 0,1);
      else
				% each w is weighted by number of training errors
				p = col_sum(x*ws > 0);
				p = (1-e).^p .* e.^(n - p);
      end
    else
      p = exp(col_sum(normcdfln(x*ws)));
    end
  end
  total = total + ws*p';
  if nargout > 1
    total2 = total2 + scale_cols(ws,p)*ws';
  end
  total_ok = total_ok + sum(p);
end
s = log(total_ok/total_sampled);
m = total/total_ok;
v = total2/total_ok;
v = v - m*m';
