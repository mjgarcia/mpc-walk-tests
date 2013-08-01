function vc = computeVelocity(lambda, Lin,e)
  vc = - lambda *pinv(Lin)*e;%* inv(L'*L)*L'*e,
  vc = vc';
end