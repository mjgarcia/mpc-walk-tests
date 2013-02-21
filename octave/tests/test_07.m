clear;
cd ../formulation_01
walk_01;
simdata_01 = simdata;

cd ../formulation_05
walk_01;
simdata_05 = simdata;


cd ../tests


figure
hold on
plot_constraint_actpattern(simdata_01)
xlabel('iteration')
ylabel('number of constraint')
hold off
print_plot('./ac_pattern_01');

figure
hold on
plot_constraint_actpattern(simdata_05)
xlabel('iteration')
ylabel('number of constraint')
hold off
print_plot('./ac_pattern_05');


%%%%%%%%%

figure
hold on
plot_constraint_actnum(simdata_01)
xlabel('iteration')
ylabel('number of constraints')
hold off
print_plot('./ac_number_01');


figure
hold on
plot_constraint_actnum(simdata_05)
xlabel('iteration')
ylabel('number of constraints')
hold off
print_plot('./ac_number_05');


%%%%%%%%%

binmat_01 = [];
binmat_05 = [];
fdactdiff = 0;
for i=1:length(simdata_01.simstep)
    binmat_01 = [binmat_01, (simdata_01.simstep(i).lambda_zmp != 0)];
    binmat_05 = [binmat_05, (simdata_05.simstep(i).lambda_zmp != 0)];
    fdactdiff = fdactdiff + sum ((simdata_01.simstep(i).lambda_fd != 0) - (simdata_05.simstep(i).lambda_fd != 0));
end
actnum_01 = sum (binmat_01);
actnum_05 = sum (binmat_05);

figure
hold on
plot(actnum_05 - actnum_01,'bo-');
xlabel('iteration')
ylabel('number of constraints')
hold off
print_plot('./ac_actnum_05_vs_01');

if (fdactdiff == 0)
    printf('Activation patterns of constraints on foot positions are identical.\n');
else
    printf('Attention! Activation patterns of constraints on foot positions differ.\n');
end
