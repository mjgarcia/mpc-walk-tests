clear;
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
simtime = (1:125) * 0.1;
plot(simtime, simdata_01.cstateProfile(2, 1:125), 'r', 'linewidth', 5)
simtime = (1:length(simdata_05.cstateProfile(2, :))) * 0.1;
plot(simtime, simdata_05.cstateProfile(2, :), 'b', 'linewidth', 5)
simtime = (1:length(refvel))*0.1;
plot(simtime, refvel, 'k', 'linewidth', 5)
legend ('NTC', 'STC, RTC', 'reference')
xlabel ('time (s)')
ylabel ('CoM velocity (m/s)')
axis tight 
%xlim auto 
hold off

print_plot('./velocity');
