function alpha = bpm_direct(task)

K = feval(task.kernel, task.X, task.X, task.kernel_args{:});
IK = inv(K);
r = task.Y./sqrt(diag(IK));
%alpha = IK*diag(Y);
alpha = IK*r;
