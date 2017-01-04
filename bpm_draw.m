function h = bpm_draw(task, alpha, varargin)
% BPM_DRAW        Draw a classification boundary.
%
% BPM_DRAW(task,w) draws the linear boundary for a task with linear kernel
% and solution vector w.
% BPM_DRAW(task,w,style) draws the boundary in the given line style.
% BPM_DRAW(task,alpha) draws the nonlinear boundary for a task with nonlinear
% kernel and dual solution vector alpha.

if isempty(task.kernel)
  w = alpha;
  if task.add_bias
    % assume the last coefficient is the bias
    h = draw_line_clip(w(1), w(3), -w(2), varargin{:});
  else
    h = draw_line_clip(w(1), 0, -w(2), varargin{:});
  end
else
	dim = cols(task.X);
	if dim ~= 2 
		error(sprintf('This BPM has %d dimensions.  Can only draw two-dimensional BPMs', dim));
	end
  % evaluate on a grid and plot contours
  ax = axis;
  rx = linspace(ax(1),ax(2),100);
  ry = linspace(ax(3),ax(4),100);
  Xt = ndgridmat(rx,ry);
  Yt = bpm_classify(task, Xt, alpha);
  Yt = reshape(Yt, length(rx), length(ry))';
  hold on
  [c,h] = contour(rx, ry, Yt, [0 0], varargin{:});
  hold off
end
if nargout < 1
  clear h;
end
