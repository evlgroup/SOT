function [x, tol] = evl_optimize_lm(prob, x0, config)
%EVL_OPTIMIZE_LM Levenberg-Marquardt Method
%
%   [x, tol] = evl_optimize_gauss_newton(prob, x0, config)
%       [value] x         : current position of the point
%       [value] tol       : shift amount of the point
%       (struct) prob     : the problem definition (See 'help evl_get_empty_problem')
%       (value)  x0       : the initial value of the point
%       (struct) config   : the parameter definition (See 'help evl_get_default_config')
%
%	Requirements
%       prob.func         : the residual equation
%       prob.deriv1st     : the first-order differential equation
%
%   Specific Parameters
%       config.initial_damping    : TODO
%       config.damping_inc_factor : TODO
%
%   Example:
%       prob = evl_get_empty_problem();
%       prob.data = 2 * rand(100, 1) - 1;
%       prob.func = @(x, data)(x - data);
%       prob.deriv1st = @(x, data)(ones(100, 1));
%       config = evl_get_default_config();
%       config.debug_verbose = true;
%       x0 = 1;
%       evl_optimize_lm(prob, x0, config)
%
%   Reference:
%       Levenberg-Marquardt algorithm (Wikipedia), https://en.wikipedia.org/wiki/Levenberg%E2%80%93Marquardt_algorithm

x_prev = x0;
x = x0;
damping = config.initial_damping;
tau = config.damping_inc_factor;

for itr = 1:config.term_max_iter
    % Compute residual and Jacobian
    r = feval(prob.func, x, prob.data);
    J = feval(prob.deriv1st, x, prob.data);
    A = J' * J;
    delta1 = -(A + damping*diag(diag(A)))^-1 * J' * r;
    delta2 = -(A + damping/tau*diag(diag(A)))^-1 * J' * r;

    % Compute sum of squared residual error
    rn1 = feval(prob.func, x + delta1, prob.data);
    rn2 = feval(prob.func, x + delta2, prob.data);
    errc = norm(r);
    errn1 = norm(rn1);
    errn2 = norm(rn2);

    % Adjust the damping factor and move to the next point
    if errc > errn2
        damping = damping / tau;
    elseif errc > errn1
        x = x + delta1;
    else
        damping = damping * tau;
    end;

    % Show debug information and pause if necessary
    tol = norm(delta1);
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
