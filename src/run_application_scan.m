close all;
clear all;

addpath('application');

% Load an image and matched features
data = load('data/scan_intel.mat');
select = [1001, 1005];
data.beam_data = data.beam_data(select,:);
data.odom      = data.odom (select,:);
data.timestamp = data.timestamp(select,:);

% Set the problem, configuration, and initial point
prob = evl_get_empty_problem();
prob.func = @scan_calc_ndt_negscore;
prob.deriv1st = @scan_calc_ndt_gradient;
prob.deriv2nd = @scan_calc_ndt_hessian;

data.ndt_cellsize = 0.5;
data.ndt_maxrange = 15;
data.ndt_mindata  = 15;
data.ndt_mineig   = 0.04;
data.xy_refer = scan_tran_range2xy(data.beam_data(1,:), data.beam_start, data.beam_end);
data.xy_query = scan_tran_range2xy(data.beam_data(2,:), data.beam_start, data.beam_end);
[data.ndt_mu, data.ndt_sigma, data.ndt_num] = scan_tran_xy2ndt(data.xy_refer, data.ndt_cellsize, data.ndt_maxrange, data.ndt_mindata, data.ndt_mineig);
prob.data = data;

config = evl_get_default_config();

x0 = [0; 0; 0];

optimizer = @evl_optimize_newton;

% Prepare to visualize the result
h_func = evl_plot_function(0, prob, [-0.3, +0.3; -0.2, +0.2; 0, 0], 10, {'X [m]', 'Y [m]'});
config.debug_plot = true;
config.debug_axes_handle = h_func;
config.debug_color = 'g';

h_proj = scan_plot_xy(0, data.xy_refer, 'b', data.ndt_maxrange);
scan_plot_xy(h_proj, data.xy_query, 'r');

% Optimize the problem with the given initial point
max_iter = config.term_max_iter;
config.term_max_iter = 1;
for itr = 1:max_iter
    % Optimize the problem, relative 2D pose estimation
    [x, tol] = feval(optimizer, prob, x0, config);

    % Visualize the result
    cla(h_proj);
    scan_plot_xy(h_proj, data.xy_refer, 'b');
    scan_plot_xy(h_proj, data.xy_query, 'r');
    R = [cos(x(3)), -sin(x(3)); sin(x(3)), cos(x(3))];
    xy_proj = R * data.xy_query'+ repmat(x(1:2), 1, data.beam_n);
    scan_plot_xy(h_proj, xy_proj', 'g');
    legend({'Refer', 'Query', 'Proj'});
    disp(['[EVL] iter = ', num2str(itr), ', x = ', num2str(x'), ', tol = ', num2str(tol)]);

    % Prepare the next optimization
    x0 = x;
    pause;
end
