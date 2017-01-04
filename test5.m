% test ability to mimic a decision tree

if 1
  X = (rand(1000,3) < 0.5);
  % this is a two-level tree with first split on x1
  Y = (X(:,1) & X(:,2)) | (~X(:,1) & X(:,3));
  Y = 2*Y-1;
  n = 100;
  i1 = 1:n;
  i2 = (n+1):length(Y);
  Xt = X(i2, :);
  Yt = Y(i2);
  X = X(i1, :);
  Y = Y(i1);
end

task = bpm_task(X,Y,0,'step',0,@kernelmtx_discrete,1e+2);
ep = train(bpm_ep(task),task);
fprintf('evidence = %g\n', ep.s)
fprintf('loo = %g\n', ep.loo)
%fprintf('stability = %g\n', ep.stability)

fprintf('train = %g\n', sum(classify(ep, X) ~= Y)/length(Y))
fprintf('test = %g\n', sum(classify(ep, Xt) ~= Yt)/length(Yt))

% results should be zero --- perfect classification.
