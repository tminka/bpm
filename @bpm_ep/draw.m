function h = draw(obj, varargin)
% DRAW(obj)
% same as BPM_DRAW but takes its arguments from obj.

if isempty(obj.kernel)
  if obj.add_bias
    % assume the last coefficient is the bias
    h = draw_line_clip(obj.mw(1), obj.mw(3), -obj.mw(2), varargin{:});
  else
    h = draw_line_clip(obj.mw(1), 0, -obj.mw(2), varargin{:});
  end
else
	dim = cols(obj.X);
	if dim ~= 2 
		error(sprintf('This BPM has %d dimensions.  Can only draw two-dimensional BPMs.', dim));
	end
  % evaluate on a grid and plot contours
  ax = axis;
  rx = linspace(ax(1),ax(2),100);
  ry = linspace(ax(3),ax(4),100);
  Xt = ndgridmat(rx,ry);
  Yt = classify(obj, Xt);
  Yt = reshape(Yt, length(rx), length(ry))';
  hold on
  [c,h] = contour(rx, ry, Yt, [0 0], varargin{:});
  hold off
end
if nargout < 1
  clear h;
end
