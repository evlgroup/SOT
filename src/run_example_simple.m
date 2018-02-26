close all;
clear all;

% The given problem
f   = @(x, data)(x.^4);
fp  = @(x, data)(4*x.^3);
fpp = @(x, data)(12*x.^2);

% Set the problem, configuration, and initial point
prob = evl_get_empty_problem();
prob.func     = f;
prob.deriv1st = fp;
prob.deriv2nd = fpp;

config = evl_get_default_config();
config.algo_lambda = 0.1;
config.debug_verbose = true;

x0 = 0.5;

% Optimize the problem with the given initial point
x = evl_optimize_gradient(prob, x0, config);

% Visualize the result
xs = -1:0.01:1;
figure('Color', [1, 1, 1]);
hold on;
    plot(xs, f(xs), 'b-');
    plot(x0, f(x0), 'gx', 'LineWidth', 2*2, 'MarkerSize', 5*2);
    plot(x, f(x), 'rx', 'LineWidth', 2*2, 'MarkerSize', 5*2);
    box on;
    xlabel('X');
    ylabel('Y');
hold off;
