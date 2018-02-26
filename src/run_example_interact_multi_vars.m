close all;
clear all;

% The given problem
[f,fp,fpp] = feval(@test_function_rosenbrock);

% Set the problem, configuration, and initial point
prob = evl_get_empty_problem();
prob.func = f;
prob.deriv1st = fp;
prob.deriv2nd = fpp;

x0 = [-2; 2];

optimizer = ...
{ ...
    'Gradient',                     @evl_optimize_gradient,                'c'; ...
    'Gradient + LineSearch',        @evl_optimize_gradient_line_search,    'r'; ...
    'Newton',                       @evl_optimize_newton,                  'm'; ...
    'Newton + TrustRegion',         @evl_optimize_newton_trust,            'k'; ...
    'Newton + Trust + SaddleFree',  @evl_optimize_newton_trust_saddlefree, 'g'; ...
    'BFGS',                         @evl_optimize_quasi_newton_BFGS,       'y'; ...
};

% Prepare to visualize the result
h = evl_plot_function(0, prob, [-3, 3 ; -3, 3]);
for method = 1:size(optimizer,1)
    x_prev{method} = x0;
    config{method} = evl_get_default_config();
    config{method}.algo_lambda = 0.0001;
    config{method}.term_max_iter = 100;
    config{method}.slope_modifier = 0.5;
    config{method}.debug_verbose = true;
    config{method}.debug_plot = true;
    config{method}.debug_axes_handle = h; 
    config{method}.debug_color = optimizer{method,3};
end

% Optimize the problem
for method = 1:size(optimizer,1)
    % Optimize the problem with each optimizer
    disp(['Press any key to start ', optimizer{method, 1}]);
    pause;
    title(optimizer{method,1});
    feval(optimizer{method,2}, prob, x_prev{method}, config{method});
    disp([optimizer{method, 1} ' is terminated.']);
    disp(' ');
    axis([-3, 3, -3, 3])
end
