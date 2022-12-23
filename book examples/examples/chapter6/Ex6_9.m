% Example 6.9 Switch sizing
clearvars;
close all;
addpath ../../lib
load 65nch.mat;
load 65pch.mat;

% Sizing parameters
k = 2.6;
ron_max = 380.7;

%Design specifications
fclk = 100e6;
epsilon = 0.1e-2;
C = 1e-12;

% Calculate required ron and device widths
ron = 1/2/fclk/C/log(1/epsilon)
scale = ron_max/ron
Wn = nch.W*scale
Wp = k*Wn
