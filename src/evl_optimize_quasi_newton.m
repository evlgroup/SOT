function [x, tol] = evl_optimize_quasi_newton(prob, x0, config)
%EVL_OPTIMIZE_QUASI_NEWTON Quasi-Newton method
%
%   [x, tol] = evl_optimize_quasi_newton(prob, x0, config)
%       [value] x         : current position of the point
%       [value] tol       : shift amount of the point
%       (struct) prob     : the problem definition (See 'help evl_get_empty_problem')
%       (value)  x0       : the initial value of the point
%       (struct) config   : the parameter definition (See 'help evl_get_default_config')
%
%	Requirements
%       prob.func         : the cost equation
%
%   Specific Parameters
%       config.lambda     : step size for calculating slope
%
%   Example:
%       prob = evl_get_empty_problem();
%       prob.func = @(x, data)(x.^3);
%       config = evl_get_default_config();
%       config.debug_verbose = true;
%       x0 = 1;
%       evl_optimize_quasi_newton(prob, x0, config)

x_prev = x0;
x = x0;
lambda = config.lambda;

for itr = 1:config.term_max_iter
    % Compute gradient and Hessian
    f0 = feval(prob.func, x - lambda, prob.data);
    f  = feval(prob.func, x, prob.data);
    f1 = feval(prob.func, x + lambda, prob.data);
    delta = -(f1 - 2*f + f0)^-1 * 0.5 * lambda * (f1 - f0);

    % Update the point, x
    x = x + delta;

    % Show debug information and pause if necessary
    tol = norm(delta);
    if config.debug_verbose
        disp(['[EVL] iter = ', num2str(itr), ', x = ', num2str(x'), ', tol = ', num2str(tol)]);
    end
    if config.debug_plot
        evl_plot_x(config.debug_axes_handle, prob, x, config.debug_color, x_prev, config.debug_color);
        x_prev = x;
    end
    if config.debug_pause
        pause;
    end

    % Check the tolerance terminal condition
    if tol < config.term_tolerance
        break;
    end
end
