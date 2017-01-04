function obj = retrain(obj, task)

if isempty(obj.kernel)
  obj = train_linear(obj, task.data');
else
  obj.X = task.X;
  obj.Y = task.Y;
  obj = train_kernel(obj, task.K);
end
