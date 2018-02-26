close all;
clear all;

addpath('application');

% Set the problem, configuration, and initial point
prob = evl_get_empty_problem();
prob.func = @line_calc_algebraic_error;
prob.deriv1st = @line_calc_algebraic_deriv1st;
prob.deriv2nd = @line_calc_algebraic_deriv2nd;
prob.data = load('data/line.csv');

config = evl_get_default_config();
config.algo_lambda = 1e-9;
config.debug_verbose = true;
config.debug_pause = true;

x0 = line_estimate_2point(prob.data);

optimizer = @evl_optimize_newton;

% Prepare to visualize the result
true_line = [-0.75, 400];
true_color = [1, 0.5, 0];
h_func = evl_plot_function(0, prob, [-1.4, 0; 200, 600], 100, {'a (slope)', 'b (y-intercept)'});
evl_plot_x(h_func, prob, true_line, true_color); % Draw the ground truth
config.debug_plot = true;
config.debug_axes_handle = h_func;
config.debug_color = 'g';

h_line = line_plot(0, true_line, true_color, [0, 600; 0, 400], prob.data); % Draw the ground truth

% Optimize the problem with the given initial point
[x, tol] = feval(optimizer, prob, x0, config);
line_plot(h_line, x0, 'g');
