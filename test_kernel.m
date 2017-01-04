% Demonstrate use of kernels within BPM
% and how to select best kernel.

load data/example2.mat
%load data/example3.mat

figure(1)
plot_data(X,Y)
axis equal
axis_pct
axis off
drawnow
set(gcf,'paperpos',[0.25 2.5 4 4])
% print -dpng example3.png

task = bpm_task(X,Y,0,'step',0,'kernelmtx_rbf',0.4);
%task = bpm_task(X,Y,0,'step',0,'kernelmtx_poly',2);
ep = train(bpm_ep(task),task);
fprintf('EP evidence = %g\n', ep.s)
draw(ep,'g')

if 0
  addpath('other/svm')
  alpha = train_svm(task);
  bpm_draw(task, alpha, 'r');
end

if 1
  % score different kernel widths
  vs = linspace(0.1,1,10);
  s = [];
  for i = 1:length(vs)
    task = bpm_task(X,Y,0,'step',0,'kernelmtx_rbf',vs(i));
    ep = train(bpm_ep(task),task);
    s(i) = ep.s;
  end
  figure(2)
  plot(vs, s)
  axis_pct
  ylabel('Marginal Likelihood')
  xlabel('Width')
  [dummy,i] = max(s);
  fprintf('best width is %g\n', vs(i));
end

