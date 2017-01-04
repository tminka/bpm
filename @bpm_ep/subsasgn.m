function obj = subsasgn(obj,index,v)
% subsasgn(obj,index,v) handles expressions of the form `obj.index = v'.

if length(index) > 1
  sub = subsref(obj,index(1));
  sub = subsasgn(sub,index(2:end),v);
  obj = subsasgn(obj,index(1),sub);
  return
end
switch index(1).type
  case '.'
    switch index(1).subs
      case 'type'
	obj.type = v;
      case 'e'
	obj.e = v;
      case 'kernel'
	obj.kernel = v;
      case 'add_bias'
	obj.add_bias = v;
      case 'X'
	obj.X = v;
      case 'Y'
	obj.Y = v;
      case 'stepsize'
	obj.stepsize = v;
      case 'mp'
	obj.mp = v;
      case 'vp'
	obj.vp = v;
      otherwise
	error('unknown or inaccessible field');
    end
  otherwise
    error('unsupported subscript type');
end
