function obj = set_kernel(obj,ker,add_bias)

obj.kernel = ker;
if nargin < 3
  add_bias = 0;
end
obj.add_bias = add_bias;
