function h = draw_vs_point(w, style, txt)
% DRAW_VS_POINT    Plot a labeled point in the version space.
%
% DRAW_VS_POINT(w,style) adds a point in the given style to the current
% plot of the version space.  W should be a vector of length 3.
% DRAW_VS_POINT(w,style,txt) also draws the label TXT next to the point.

hold on
w = w/norm(w);
if length(w) == 2
  h = plot(w(1), w(2), style);
else
  w = w*1.1;
  h = plot3(w(1), w(2), w(3), style);
  if nargin > 2
    c = 0.05;
    h(2) = text(w(1), w(2)+c, w(3)+c, txt);
    set(h(2),'FontSize',6);
  end
end
hold off
if nargout < 1
  clear h
end
