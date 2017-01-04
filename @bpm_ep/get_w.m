function w = get_w(obj)

if isempty(obj.kernel)
  w = obj.mw;
else
  error('w not defined for this kernel')
end
