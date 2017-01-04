function h = draw_ellipsoid(m, v, color)
%DRAW_ELLIPSOID
%
% DRAW_ELLIPSOID(m,v) draws a 1-sigma ellipse to represent a Gaussian with
% mean m and variance v.
%
% See also show_vs, draw_vs_point.

if nargin < 3
  color = [1 0 0.5];
end
if length(m) == 2
  h = draw_ellipse(m,v,color);
  return
end
c = chol(v);
[x,y,z] = sphere(50);
s = size(x);
p = [x(:) y(:) z(:)]*c;
p = p + repmat(m', rows(p), 1);
x = reshape(p(:,1), s);
y = reshape(p(:,2), s);
z = reshape(p(:,3), s);
held = ishold;
hold on
h = surf(x,y,z);
set(h,'FaceColor','interp','EdgeColor','none');
set(h,'FaceColor',color);
set(h,'AmbientStrength',0.3,'DiffuseStrength', 0.8, 'SpecularStrength', 1, ...
    'SpecularExponent', 10, 'SpecularColorReflectance', 1.0);
if ~held
  hold off
end
if nargout < 1
  clear h
end
