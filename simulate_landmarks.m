function [su, sv] = simulate_landmarks(mpc, simdata, vs_params)

x = simdata.cstateProfile(1:mpc.Ns:end, end);
y = simdata.cstateProfile(4:mpc.Ns:end, end);

Nlm = length(vs_params.cu);
su = zeros(mpc.N, Nlm);
sv = zeros(mpc.N, Nlm);

for l=1:Nlm
    su(:,l) = vs_params.au*x + vs_params.bu*y + vs_params.cu(l);
    sv(:,l) = vs_params.av*x + vs_params.bv*y + vs_params.cv(l);
end