% simple separable example (the three-point problem).
% no kernel, explicit bias.
% tests @bpm_ep/train_linear.m

load data/three_pts.mat
%load data/six_pts.mat

if 0
  % demonstrates that BPM can have small margin
  X = [0 -1; 0 1; .4 0];
  Y = [1; 1; -1];
end

figure(1)
clf
plot_data(X,Y);
axis_pct;
%axis([-0.5 1.5 -0.5 1.5])
axis equal
drawnow
%set(gca,'Xtick',[],'Ytick',[])
%axis off
set(gcf,'paperpos',[0.25 2.5 5 5])
%print -dpng 3pts.png

if 0
  draw_line_clip(1,-0.9,-0.7,'r')
  print -dpng 3pts_per.png

  draw_line_clip(1,-0.5,0,'r')
  print -dpng 3pts_svm.png
end

task = bpm_task(X,Y);

% EP
ep = train(bpm_ep(task), task);
figure(1)
draw(ep, 'g')
% print -dpng 3pts_bpm.png

figure(2)
show_vs(task,ep.mw)
draw_vs_point(ep.mw, 'rx', 'EP')
%draw_ellipsoid(get_w(ep), get_v(ep))

% Brute
[brute.s,brute.m,brute.v] = bpm_brute(task,1e6);
figure(1)
bpm_draw(task,brute.m,'k')
figure(2)
draw_vs_point(brute.m,'o','True')

if 1
  % compare to brute
  fprintf('Volume (True,EP):\n')
  disp([brute.s ep.s])
  fprintf('Mean (True,EP):\n')
  disp([brute.m ep.mw])
  fprintf('Variance (True):\n')
  disp(brute.v)
  fprintf('Variance (EP):\n')
  disp(ep.vw)
end

if 0
  addpath('other/svm')
  alpha = train_svm(task);
  bpm_draw(task, alpha, 'r');
end

