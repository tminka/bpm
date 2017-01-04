function obj = bpm_ep(task)
% BPM_EP         Create a BPM_EP object.
%
% You can access this object just like a structure, e.g.
%   disp(obj.kernel)
%   obj.e = 0.3;
%
% Description of fields:
%   type        Type of error model ('step' or 'probit').
%   e           Error rate for uniform error model (type == 'step').
%   kernel      Function to compute kernel matrix. If empty, kernel is linear.
%   add_bias    If true, a "1" is appended to every input vector.
%   s           Marginal likelihood.
%   mw,vw       Posterior mean and variance of w (empty kernel only).
%   alpha       Posterior mean for nonempty kernel.
%   X,Y         Training data (needed for nonempty kernel).
%   mp,vp       Prior mean and variance of w.
%   restrict
%   stepsize
%   state       Internal state of EP, so that it can be restarted.
%   train_err
%   loo
%   loo_count
%   stability

if isempty(task.kernel)
  task.kernel_args = [];
end

% in the kernel case we must store the entire training set
s = struct('type', task.type, 'e', task.e, 'add_bias', task.add_bias, ...
    'kernel', task.kernel, 'kernel_args', {task.kernel_args}, ...
    'mp', [], 'vp', [], ...
    's', [], 'mw', [], 'vw', [], ...
    'alpha', [], 'bias', 0, 'X', [], 'Y', [], ...
    'state', [], 'restrict', 0, 'stepsize', 1, ...
    'train_err', [], 'loo', [], 'loo_count', [], 'stability', []);
%    'loo', [], 'loo_count', [], 'stability', []);
obj = class(s, 'bpm_ep');
