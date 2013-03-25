figure

load ../data/test_01_result.dat

subplot(4,1,1);
hold on
%baseval = disturbProfile(1);
%baseval = 0.05;
%barh(1, disturbProfile(sum(fail_success_12 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'k');
%barh(2, disturbProfile(sum(fail_success_13 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'b');
%barh(3, disturbProfile(sum(fail_success_18 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'r');
start_ind = sum(fail_success_12 == -1);
end_ind = sum(fail_success_13 == -1) + 1;
fail_success_12 = fail_success_12(start_ind:end_ind);
fail_success_13 = fail_success_13(start_ind:end_ind);
fail_success_18 = fail_success_18(start_ind:end_ind);
disturbProfile = disturbProfile(start_ind:end_ind);

plot(disturbProfile(fail_success_12  < 0), 1*ones(sum(fail_success_12  < 0), 1), '-bo', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  < 0), 2*ones(sum(fail_success_13  < 0), 1), '-co', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  < 0), 3*ones(sum(fail_success_18  < 0), 1), '-ko', 'linewidth', 15, 'markersize', 5);

plot(disturbProfile(fail_success_12  > 0), 1*ones(sum(fail_success_12  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  > 0), 2*ones(sum(fail_success_13  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  > 0), 3*ones(sum(fail_success_18  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);

%set(gca,'ytick',[]);
ylabel ({'from', 'the left'})
axis tight
set(gca,'ytick',[1,2,3]);
set(gca,'ylim',[0, 4]);
set (gca(), 'yticklabel', 'STC|NTC|RTC')
set(gca(),'xtick', get(gca(),'xtick') )
set (gca(), 'position', [0.15, 0.85, 0.8, 0.12])
hold off


load ../data/test_03_result.dat

subplot(4,1,2);
hold on
%baseval = disturbProfile(1);
%baseval = 0.15;
%barh(1, disturbProfile(sum(fail_success_12 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'k');
%barh(2, disturbProfile(sum(fail_success_13 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'b');
%barh(3, disturbProfile(sum(fail_success_18 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'r');
start_ind = sum(fail_success_12 == -1);
end_ind = sum(fail_success_13 == -1) + 1;
fail_success_12 = fail_success_12(start_ind:end_ind);
fail_success_13 = fail_success_13(start_ind:end_ind);
fail_success_18 = fail_success_18(start_ind:end_ind);
disturbProfile = disturbProfile(start_ind:end_ind);

plot(disturbProfile(fail_success_12  < 0), 1*ones(sum(fail_success_12  < 0), 1), '-bo', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  < 0), 2*ones(sum(fail_success_13  < 0), 1), '-co', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  < 0), 3*ones(sum(fail_success_18  < 0), 1), '-ko', 'linewidth', 15, 'markersize', 5);

plot(disturbProfile(fail_success_12  > 0), 1*ones(sum(fail_success_12  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  > 0), 2*ones(sum(fail_success_13  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  > 0), 3*ones(sum(fail_success_18  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);

%set(gca,'ytick',[]);
ylabel ({'from', 'the right'})
%ylabel ('from the right')
axis tight
set(gca,'ytick',[1,2,3]);
set(gca,'ylim',[0, 4]);
set (gca(), 'yticklabel', 'STC|NTC|RTC')
set(gca(),'xtick', get(gca(),'xtick') )
set (gca(), 'position', [0.15, 0.6, 0.8, 0.12])
hold off


load ../data/test_04_result.dat

h = subplot(4,1,3);
hold on
%baseval = disturbProfile(1);
%baseval = 0.17;
%barh(1, disturbProfile(sum(fail_success_12 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'k');
%barh(2, disturbProfile(sum(fail_success_13 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'b');
%barh(3, disturbProfile(sum(fail_success_18 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'r');
start_ind = sum(fail_success_12 == -1);
end_ind = sum(fail_success_13 == -1) + 1;
fail_success_12 = fail_success_12(start_ind:end_ind);
fail_success_13 = fail_success_13(start_ind:end_ind);
fail_success_18 = fail_success_18(start_ind:end_ind);
disturbProfile = disturbProfile(start_ind:end_ind);

plot(disturbProfile(fail_success_12  < 0), 1*ones(sum(fail_success_12  < 0), 1), '-bo', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  < 0), 2*ones(sum(fail_success_13  < 0), 1), '-co', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  < 0), 3*ones(sum(fail_success_18  < 0), 1), '-ko', 'linewidth', 15, 'markersize', 5);

plot(disturbProfile(fail_success_12  > 0), 1*ones(sum(fail_success_12  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  > 0), 2*ones(sum(fail_success_13  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  > 0), 3*ones(sum(fail_success_18  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);

%set(gca,'ytick',[]);
ylabel ({'from', 'the back'})
%ylabel ('from the back')
axis tight
set(gca,'ytick',[1,2,3]);
set(gca,'ylim',[0, 4]);
set (gca(), 'yticklabel', 'STC|NTC|RTC')
set(gca(),'xtick', get(gca(),'xtick') )
set (gca(), 'position', [0.15, 0.35, 0.8, 0.12])
hold off


load ../data/test_05_result.dat

subplot(4,1,4);
hold on
%baseval = disturbProfile(1);
%baseval = 0.3;
%barh(1, disturbProfile(sum(fail_success_12 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'k');
%barh(2, disturbProfile(sum(fail_success_13 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'b');
%barh(3, disturbProfile(sum(fail_success_18 == -1)), 0.5, 'basevalue', baseval, 'facecolor', 'r');
start_ind = sum(fail_success_12 == -1);
end_ind = sum(fail_success_13 == -1) + 1;
fail_success_12 = fail_success_12(start_ind:end_ind);
fail_success_13 = fail_success_13(start_ind:end_ind);
fail_success_18 = fail_success_18(start_ind:end_ind);
disturbProfile = disturbProfile(start_ind:end_ind);

plot(disturbProfile(fail_success_12  < 0), 1*ones(sum(fail_success_12  < 0), 1), '-bo', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  < 0), 2*ones(sum(fail_success_13  < 0), 1), '-co', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  < 0), 3*ones(sum(fail_success_18  < 0), 1), '-ko', 'linewidth', 15, 'markersize', 5);

plot(disturbProfile(fail_success_12  > 0), 1*ones(sum(fail_success_12  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_13  > 0), 2*ones(sum(fail_success_13  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);
plot(disturbProfile(fail_success_18  > 0), 3*ones(sum(fail_success_18  > 0), 1), '-ro', 'linewidth', 15, 'markersize', 5);

%set(gca,'ytick',[]);
ylabel ({'from', 'the front'})
%ylabel ('from the front')
axis tight
set(gca,'ytick',[1,2,3]);
set(gca,'ylim',[0, 4]);
set (gca(), 'yticklabel', 'STC|NTC|RTC')
set(gca(),'xtick', get(gca(),'xtick') )
set (gca(), 'position', [0.15, 0.1, 0.8, 0.12])
hold off

xlabel ('magnitude of perturbation (m/s)')

pp_options = struct('apply_tick_fix', false, 'pdf_crop', false, 'eps2eps', true, 'fontsize', 16);
print_plot('perturbations', pp_options);
