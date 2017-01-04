% willBuy data
X = [63 38; 16 23; 28 40; 55 27; 22 18; 20 40];
Y = [1 -1 1 1 -1 -1];

task = bpm_task(X,Y,1,'probit');
ep = train(bpm_ep(task), task);
ep.s
