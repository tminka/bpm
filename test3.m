% Measures the accuracy of EP on 1-D probit observations.

if 1
  n = 5;
  Y = sign(2*rand(1,n)-1);
else
  load data/bits.mat
end
%Y = [1 -1 -1];
%Y = 1;
n = length(Y);
X = ones(n,1);
if 0
  % make X smaller so the posterior is more Gaussian
  X = X/10;
end
if 0
  % make X bigger to make the posterior less Gaussian
  X = X*10;
end
XY = X.*Y(:);

task = bpm_task(X,Y,0,'probit');
ep = train(bpm_ep(task),task);
%ep = set_restrict(ep,1);
%ep = set_kernel(ep,[],0);
%ep = set_stepsize(ep,0.5);

% plot the true posterior and the EP approximation
ws = -5:0.01:5;
f = [];
for i = 1:length(ws)
  f(i) = sum(normcdfln(XY*ws(i)));
end
% prior
f = f + mvnormpdfln(ws);
g = mvnormpdfln(ws, ep.mw, [], ep.vw) + ep.s;
figure(1)
plot(ws,exp(f))
xlabel('w')
ylabel('p(D|w)')
drawnow
axis manual
hold on
plot(ws,exp(g),'g')
hold off
legend('True','EP')

inc = (ws(2)-ws(1))/length(ws);
z1 = sum(exp(f))*inc;
z2 = sum(exp(g))*inc;
fprintf('true integral = %g\n', z1)
fprintf('  EP integral = %g\n', z2)
m1 = sum(ws.*exp(f))*inc/z1;
m2 = sum(ws.*exp(g))*inc/z2;
fprintf('true mean = %g\n', m1)
fprintf('  EP mean = %g\n', m2)
v1 = sum(ws.*ws.*exp(f))*inc/z1 - m1^2;
v2 = sum(ws.*ws.*exp(g))*inc/z2 - m2^2;
fprintf('true variance = %g\n', v1)
fprintf('  EP variance = %g\n', v2)

