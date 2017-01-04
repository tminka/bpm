function p = bpm_likelihood(task, w)
%BPM_LIKELIHOOD
%
% BPM_LIKELIHOOD(task, w) returns the likelihood of the task data
% under the parameter vector w.  
% If w is a matrix, each column a parameter vector, then the return value is
% a row vector of likelihoods.

if ~isempty(task.kernel)
  error('doesn''t work with kernels');
end

X = task.data;
z = X*w;
e = task.e;
% z is a column vector or matrix of columns
if strcmp(task.type, 'step')
  if e == 0
    p = double(all(z > 0,1));
  else
    n = rows(X);
    p = sum(z > 0);
    p = (1-e).^p .* e.^(n-p);
  end
else
  p = exp(col_sum(normcdfln(z/e)));
end
