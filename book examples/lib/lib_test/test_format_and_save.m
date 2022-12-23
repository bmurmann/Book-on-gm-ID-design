% Test format_and_save function
clearvars;
close all;
addpath ..

h = figure;
plot(1:10, 'ko-')
xlabel('x-axis')
ylabel('y-axis')

format_and_save(h, 'Fig1_1', 'W', 3, 'H', 3, 'FontSize', 6);
