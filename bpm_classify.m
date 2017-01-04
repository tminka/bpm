function [Y,z] = bpm_classify(task, X, alpha)
% BPM_CLASSIFY     Classify test data
%
% BPM_CLASSIFY(task, X, w) classifies the rows in X according to the
% learned weights w (linear kernel) and the task parameters.
% BPM_CLASSIFY(task, X, alpha) classifies according to the dual solution
% alpha (nonlinear kernel).
% alpha is assumed to be multiplied by task.Y.

if isempty(task.kernel)
  w = alpha;
  if task.add_bias
    z = X*w(1:end-1) + w(end);
  else
    z = X*w;
  end
else
  if task.add_bias
    X = [X ones(rows(X), 1)];
  end
  K = feval(task.kernel, X, task.X, task.kernel_args{:});
  z = K*alpha;
end
Y = sign(z);
