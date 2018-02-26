close all;
clear all;

addpath('application');

% Load range data
%data = scan_load_clf('data/scan_intel.clf');
data = load('data/scan_intel.mat'); % To accelerate loading

% Draw the initial beam data
cellsize = 1.0;
range    = 15;
mindata  = 5;
mineig   = 0.04;
xy = scan_tran_range2xy(data.beam_data(1,:), data.beam_start, data.beam_end);
h_data = scan_plot_xy(0, xy, 'r', range);

% Draw the next beam data
for k = 2:size(data.beam_data,1)
    xy = scan_tran_range2xy(data.beam_data(k,:), data.beam_start, data.beam_end);
    [ndt_mu, ndt_sigma, ndt_num] = scan_tran_xy2ndt(xy, cellsize, range, mindata, mineig);
    cla();
    scan_plot_xy(h_data, xy, 'r');
    scan_plot_ndt(h_data, ndt_mu, ndt_sigma, ndt_num);
    text(0, 1.1, ['Frame: ', num2str(k)], 'Unit', 'normalized');
    drawnow;
end
