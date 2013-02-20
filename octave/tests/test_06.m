cd ../formulation_01
walk_04;
simdata_01 = simdata;

cd ../formulation_05
walk_04;
simdata_05 = simdata;


cd ../tests

refvel = [mpc_state.pwin.cvel_ref](1,:);

figure
hold on
plot(simdata_01.cstateProfile(2, 1:145), 'r', 'linewidth', 3)
plot(simdata_05.cstateProfile(2, :), 'b', 'linewidth', 3)
plot(refvel, 'k')
xlabel ('iteration')
ylabel ('velocity (m/s)')
hold off

print_plot('./velocity');
