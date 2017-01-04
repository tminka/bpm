function task = bpm_task(X,Y,add_bias,type,e,kernel,varargin)
% BPM_TASK        Create a BPM_TASK object.
%
% BPM_TASK(X,Y) returns a task object with default parameters:
% add_bias = 1, type = 'step', e = 0, linear kernel.
% X(i,:) is an observation, Y(i) is the corresponding label (1 or -1).
% BPM_TASK(X,Y,add_bias,type,e) returns a task object with linear
% kernel and the parameters specified.
% BPM_TASK(X,Y,add_bias,type,e,kernel,kernel_args) returns a task object
% with the kernel function and kernel parameters specified.
%
% Description of fields:
%   add_bias    If true, a "1" is appended to every input vector.
%   type        Type of error model ('step' or 'probit').
%   e           Error rate for uniform error model (type == 'step').
%   kernel      Function to compute kernel matrix. If empty, kernel is linear.
%   kernel_args Extra arguments to pass to kernel function (e.g. width).

if nargin < 3
  add_bias = 1;
end
if nargin < 6
  kernel = [];
end
if nargin < 4
  type = 'step';
end
if nargin < 5
  if strcmp(type,'probit')
    e = 1;
  else
    e = 0;
  end
end
if add_bias
  X = [X ones(rows(X),1)];
end
if isempty(kernel)
  data = scale_rows(X,Y);
  task = struct('data',data,'type',type,'e',e,'add_bias',add_bias,...
      'kernel',kernel);
else
  K = feval(kernel,X,X,varargin{:});
  K = scale_rows(scale_cols(K, Y), Y);
  task = struct('K',K,'X',X,'Y',Y,'type',type,'e',e,'add_bias',add_bias,...
      'kernel',kernel,'kernel_args',{varargin});
end
