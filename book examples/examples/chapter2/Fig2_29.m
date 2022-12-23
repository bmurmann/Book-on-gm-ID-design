% 2.3.8   current gain versus frequency for L = 65 nm and gm/ID = 9.6 S/A
clear all
close all
addpath ../../lib

% Load SPICE data
load Fig2_29.mat
magdb = 20*log10(abs(idn./ign));
magdb_neut = 20*log10(abs(idn_neut./ign_neut));

h = figure;
semilogx(f, zeros(1, length(f)), 'k:');
hold on;
semilogx(f, magdb, 'k-', 'linewidth', 1);
semilogx(f, magdb_neut, 'k--', 'linewidth', 1);
xlabel('Frequency  (Hz)')
ylabel('|{\iti_o_u_t}/{\iti_i_n}|')
axis([1e9 1e12 -30 40]);

%format_and_save(h, 'Fig2_29')
