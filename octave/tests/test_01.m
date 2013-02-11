cd ../formulation_12
walk_01_02;
cpProfile_12 = cpProfile;

cd ../formulation_13
walk_01_02;
cpProfile_13 = cpProfile;

cd ../formulation_18
walk_01_02;
cpProfile_18 = cpProfile;

figure
hold on
plot(disturbProfile(1:length(cpProfile_12)), cpProfile_12, 'r')
plot(disturbProfile(1:length(cpProfile_12)), cpProfile_12, 'ro')
plot(disturbProfile, cpProfile_13, 'b');
plot(disturbProfile, cpProfile_13, 'bd');
plot(disturbProfile, cpProfile_18, 'k');
plot(disturbProfile, cpProfile_18, 'kx');
xlabel ('disturbance (meter/second)')
ylabel ('divergence (meter)')
hold off

cd ../tests
set(gca(),'xtick', get(gca(),'xtick') )
print -deps -color -F:18 ./test_01.eps
