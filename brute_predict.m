function yt = bayes_predict_brute(xt, x, prior, nsamples)

d = rows(x);
nt = cols(xt);
groupsize = 100000;
yt = zeros(1,nt);
total_ok = 0;

while(nsamples > 0)
  howmany = min([nsamples 100000]);
  disp(['sampling ' num2str(howmany)])
  ws = sample(prior, howmany);
  nsamples = nsamples - howmany;
  % project onto unit sphere
  ws = ws./repmat(sqrt(sum(ws.^2)), rows(ws), 1);
  ok = all(ws'*x > 0,2);
  ws = ws(:,ok);
  yt = yt + col_sum(sign(ws'*xt));
  total_ok = total_ok + sum(ok);
end
yt = yt/total_ok;
