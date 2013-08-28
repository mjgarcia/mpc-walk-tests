function [su, sv] = simulate_landmarks(mpc, simdata, vs_params, lm_proj, Nlm)

vx = simdata.cstateProfile(2:mpc.Ns:end, end);
vy = simdata.cstateProfile(5:mpc.Ns:end, end);

integralVX = cumsum(vx);
integralVY = cumsum(vy);

su = zeros(mpc.N, Nlm);
sv = zeros(mpc.N, Nlm);

for l=1:Nlm
    su(:,l) = vs_params.au(l)*integralVX + vs_params.bu(l)*integralVY + lm_proj(1,l);
    sv(:,l) = vs_params.av(l)*integralVX + vs_params.bv(l)*integralVY + lm_proj(2,l);
end