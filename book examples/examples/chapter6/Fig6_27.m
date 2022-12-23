% Fig. 6.27 Self-loading factors along the sizing iterations for Ex. 6.7
clearvars;
close all;
addpath ../../lib
load Fig6_27.mat

% plot
h1 = figure;
plot(1:length(rself1), rself1, 'k-o', 1:length(rself2), rself2, 'k-sq', 'linewidth', 1.01)
xlabel('Iteration');
axis([1 length(rself1) 0 0.6])
grid;
legend('\itr_s_e_l_f_1', '\itr_s_e_l_f_2', 'location', 'best')

%format_and_save(h1, 'Fig6_27')
