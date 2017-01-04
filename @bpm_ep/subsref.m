function v = subsref(obj,index)
% subsref(obj,index) handles expressions of the form `obj.index'.

switch index(1).type
  case '.'
    switch index(1).subs
      case 'type'
	v = obj.type;
      case 'e'
	v = obj.e;
      case 'kernel'
	v = obj.kernel;
      case 'add_bias'
	v = obj.add_bias;
      case 's'
	v = obj.s;
      case 'mw'
	v = obj.mw;
      case 'vw'
	v = obj.vw;
      case 'alpha'
	v = obj.alpha;
      case 'X'
	v = obj.X;
      case 'Y'
	v = obj.Y;
      case 'mp'
	v = obj.mp;
      case 'vp'
	v = obj.vp;
      case 'stepsize'
	v = obj.stepsize;
      case 'train_err'
	v = obj.train_err;
      case 'loo'
	v = obj.loo;
      otherwise
	error('unknown or inaccessible field');
    end
  otherwise
    error('unsupported subscript type');
end
if length(index) > 1
  % recurse on remaining subscripts
  v = subsref(v,index(2:end));
end
