% simple nonseparable example.
% step and probit behave differently.

load data/six_pts.mat
if 0
  X = [X; -1 0];
  Y = [Y; 1];
end
if 0
  X = [0 0];
  Y = 1;
end
if 0
  task = bpm_task(1,1,0,'step',0);
  ep = train(bpm_ep(task), task);
  [ep.mw ep.vw]
end

figure(1),clf
plot_data(X,Y);
axis_pct
drawnow

task = bpm_task(X,Y,1,'step',0.1);
ep = train(bpm_ep(task), task);

task2 = bpm_task(X,Y,1,'probit',1);
ep2 = train(bpm_ep(task2), task2);

draw(ep, 'g');
draw(ep2, 'r');
legend('class1','class2','Step','Probit')

figure(2),clf
show_vs(task,ep.mw);
draw_vs_point(ep.mw,'rx','Step')
draw_vs_point(ep2.mw,'ro','Probit')
