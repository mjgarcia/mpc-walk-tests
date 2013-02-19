cd ../formulation_01
walk_04;
simdata_01 = simdata;

cd ../formulation_05
walk_04;
simdata_05 = simdata;

refvel = [mpc_state.pwin.cvel_ref](1,:);

figure
hold on
plot(simdata_01.cstateProfile(2, 1:140), 'r')
plot(140, simdata_01.cstateProfile(2, 140), 'rx')
plot(simdata_05.cstateProfile(2, :), 'b')
plot(refvel, 'k')
xlabel ('iteration')
ylabel ('velocity (m/s)')
hold off

cd ../tests
print_plot('./velocity');
