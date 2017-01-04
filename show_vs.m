function show_vs(task,w,resolution,fun,varargin)
% SHOW_VS(task,w) plots the version space on the sphere.
% task is a bpm_task with type 'step' and empty kernel.
% w is weight vector on which the view is centered.
%
% See also draw_vs_point, draw_ellipsoid.

if ~isempty(task.kernel)
  error('unsupported task type');
end
if nargin < 4
  fun = @bpm_likelihood;
end
clf
data = task.data;
[n,d] = size(data);
if d == 2
  % 1D version space on the circle
  if nargin < 3
    resolution = 200;
  end
  if 1
    % plot the likelihood as color on the surface
    if 0
      r = linspace(-1.2,1.2,100);
      ws = ndgridmat(r,r);
      logp = feval(fun,task,ws',varargin{:});
			c = reshape(logp,length(r),length(r))';
      h = imagesc(r,r,-c);
      set(gca,'YDir','normal');
			if 0
				% compute the posterior mean (this is affected by cropping)
				p = exp(logp - max(logp));
				m = p*ws;
				m = m/norm(m);
				hold on
				plot(m(:,1),m(:,2),'go')
				hold off
			end
    end
    if 1
      thetas = linspace(0,2*pi,resolution)';
      ws = [cos(thetas) sin(thetas)];
      logp = feval(fun,task,ws',varargin{:});
      h = patch(ws(:,1),ws(:,2),-logp,'EdgeColor','interp','FaceColor','none');
			if 0
				% compute the posterior mean (needs high resolution)
				p = exp(logp - max(logp));
				%size(ws)
				%keyboard
				m = p*ws;
				m = m/norm(m);
				hold on
				plot(m(:,1),m(:,2),'go')
				hold off
			end
    end
    colormap bone
  else
    draw_circle([0;0], 1, 'b');
  end
  axis([-1 1 -1 1]*1.2)
  for i = 1:n
		if data(i,1) > 0
			linespec = 'b';
		else
			linespec = 'g';
		end
    draw_line_clip(data(i,1), 0, -data(i,2), linespec);
  end
  return
end
if d ~= 3
  error('version space is not 2D')
end

% plot a sphere
if nargin < 3
  resolution = 30;
end
[x,y,z] = sphere(resolution);
h = surf(x,y,z);
shading interp
if 1
  % plot the likelihood as color on the surface
  ws = [x(:) y(:) z(:)];
  c = feval(fun,task,ws',varargin{:});
  c = reshape(c,size(x));
  set(h, 'CData', c)
elseif 0
  % Laplacian prior
  b = 1;
  c = (b/2*exp(-b*abs(x))) .* (b/2*exp(-b*abs(y))) .* (b/2*exp(-b*abs(z)));
  set(h, 'CData', c)
  %set(h, 'CDataMapping', 'direct')
else
  set(h,'FaceColor',[1 1 0]);
end

% use either of these to kill highlights: (but they don't work)
%material dull
%set(h,'SpecularStrength',0)

set(h,'AmbientStrength',0.5)
set(h,'DiffuseStrength',0.5)

w = w/norm(w)*1.1;
view(w);
spotlight = 0;
if spotlight
  % put a spotlight on w
  light('Position',w);
  light('Position',w,'Style','local');
end
corners = [-1 -1; 1 -1; 1 1; -1 1]';
xs = corners(1,:);
ys = corners(2,:);
warning off MATLAB:divideByZero
c = 0;
z = (c - data(:,1)*xs - data(:,2)*ys)./repmat(data(:,3),1,4);
y = (c - data(:,1)*xs - data(:,3)*ys)./repmat(data(:,2),1,4);
x = (c - data(:,2)*xs - data(:,3)*ys)./repmat(data(:,1),1,4);
xok = all(abs(x)<1+eps,2);
y(xok,:) = repmat(xs,sum(xok),1);
z(xok,:) = repmat(ys,sum(xok),1);
yok = ~xok & all(abs(y)<1+eps,2);
x(yok,:) = repmat(xs,sum(yok),1);
z(yok,:) = repmat(ys,sum(yok),1);
zok = ~xok & ~yok & all(abs(z)<1+eps,2);
x(zok,:) = repmat(xs,sum(zok),1);
y(zok,:) = repmat(ys,sum(zok),1);
s = 1.1;
x = x*s; y = y*s; z = z*s;
h = [];
if strcmp(task.type,'step') && task.e == 0
	for i = 1:n
		% plot a hyperplane
		if 0
			% red faces toward invalid solutions
			z = (-1e-2 - x*data(1,i) - y*data(i,2))/data(i,3);
			patch(x,y,z,[1 0 0])
		end
		% cyan faces toward valid solutions
		h(i) = patch(x(i,:),y(i,:),z(i,:),[0 1 1]);
	end
end
% this brightens without killing lighting
set(h,'AmbientStrength',0.3)
%set(h,'SpecularStrength',1)
% this kills lighting effects
set(h,'DiffuseStrength',0.5);

% gouraud shows edges better
%lighting gouraud
axis([-1 1 -1 1 -1 1]*1.1)
axis square
axis off
