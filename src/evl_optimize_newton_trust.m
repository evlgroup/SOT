function [x, tol, tr_radius] = evl_optimize_newton_trust(prob, x0, config)
%EVL_OPTIMIZE_NEWTON_TRUST Newton method with trust region method
%
%   [x, tol] = evl_optimize_newton_trust(prob, x0, config)
%       [value] x         : current position of the point
%       [value] tol       : shift amount of the point
%       (struct) prob     : the problem definition (See 'help evl_get_empty_problem')
%       (value)  x0       : the initial value of the point
%       (struct) config   : the parameter definition (See 'help evl_get_default_config')
%
%	Requirements
%       prob.func         : the cost equation
%       prob.deriv1st     : the first-order differential equation
%       prob.deriv2st     : the second-order differential equation
%
%   Specific Parameters
%       config.initial_tr_radius          : TODO
%       config.acceptable_reduction_ratio : TODO
%       config.good_reduction_ratio       : TODO
%       config.tr_inc_factor              : TODO
%       config.tr_dec_factor              : TODO
%
%   Example:
%       prob = evl_get_empty_problem();
%       prob.func = @(x, data)(x.^4);
%       prob.deriv1st = @(x, data)(4*x.^3);
%       prob.deriv2nd = @(x, data)(12*x.^2);
%       config = evl_get_default_config();
%       config.debug_verbose = true;
%       x0 = 1;
%       evl_optimize_newton_trust(prob, x0, config)

x_prev = x0;
x = x0;
tr_radius = config.initial_tr_radius;

for itr = 1:config.term_max_iter
    % Compute gradient and Hessian
    fp = feval(prob.deriv1st, x, prob.data);
    fpp = feval(prob.deriv2nd, x, prob.data);
    delta = -fpp^-1 * fp;
    if norm(delta) > tr_radius,
        delta = delta / norm(delta) * tr_radius;
    end

    % Compute reduction ratio
    fc = feval(prob.func, x, prob.data);
    fn = feval(prob.func, x+delta, prob.data);
    qn = fc + fp' * delta + delta'* fpp * delta / 2;
    rr = (fc - fn) / (fc - qn);

    % Move to next point and adjust trust region
    if rr >= config.good_reduction_ratio,
        x = x + delta;
        tr_radius = config.tr_inc_factor * tr_radius;
    elseif rr >= config.acceptable_reduction_ratio,
        x = x + delta;
    else
        tr_radius = config.tr_dec_factor * tr_radius;
    end

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
