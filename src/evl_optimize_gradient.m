function [x, tol] = evl_optimize_gradient(prob, x0, config)
%EVL_OPTIMIZE_GRADIENT Gradient-decent method
%
%   [x, tol] = evl_optimize_gradient(prob, x0, config)
%       [value] x         : current position of the point
%       [value] tol       : shift amount of the point
%       (struct) prob     : the problem definition (See 'help evl_get_empty_problem')
%       (value)  x0       : the initial value of the point
%       (struct) config   : the parameter definition (See 'help evl_get_default_config')
%
%	Requirements
%       prob.deriv1st     : the first-order differential equation
%
%   Specific Parameters
%       config.lambda     : step size
%
%   Example:
%       prob = evl_get_empty_problem();
%       prob.deriv1st = @(x, data)(4*x.^3);
%       config = evl_get_default_config();
%       config.debug_verbose = true;
%       x0 = 1;
%       evl_optimize_gradient(prob, x0, config)
%
%   Reference:
%       Gradient descent (Wikipedia), https://en.wikipedia.org/wiki/Gradient_descent

x_prev = x0;
x = x0;

for itr = 1:config.term_max_iter
    % Update the point, x
    fp = feval(prob.deriv1st, x, prob.data);
    delta = -config.lambda * fp;
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
