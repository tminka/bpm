function v = get_v(obj)

if isempty(obj.kernel)
  v = obj.vw;
else
  error('kernel does not support get_v')
end
