function [x, tol, B] = evl_optimize_quasi_newton_BFGS(prob, x0, config)
%EVL_OPTIMIZE_QUASI_NEWTON_BFGS Quasi-Newton method (BFGS)
%
%   [x, tol] = evl_optimize_quasi_newton_BFGS(prob, x0, config)
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
%       config.B          : The initial approximated Hessian matrix
%
%   Example:
%       prob = evl_get_empty_problem();
%       prob.func = @(x, data)(x.^3);
%       config = evl_get_default_config();
%       config.debug_verbose = true;
%       x0 = 1;
%       [x, tol, B] = evl_optimize_quasi_newton_BFGS(prob, x0, config)

x_prev = x0;
x = x0;
B = config.B;
if ~isequal(size(B), [size(x,1), size(x,1)])
    B = eye(size(x,1));
end

for itr = 1:config.term_max_iter
    % Update the point, x
    fp  = feval(prob.deriv1st, x, prob.data);
    p = -B * fp;
    alpha = linesearch_secant(prob.deriv1st, x, prob.data, p);
    s = alpha * p;
    x = x + s;

    % Update the approximated Hessian matrix, B
    y = feval(prob.deriv1st, x, prob.data) - fp;
    B = B + (s'*y+y'*B*y)*(s*s')/(s'*y)^2 - (B*y*s'+s*y'*B)/(s'*y);

    % Show debug information and pause if necessary
    tol = norm(s);
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

end % End of 'function evl_optimize_quasi_newton_BFGS'



function alpha = linesearch_secant(grad, x, data, d)
% grad : gradient of function
% x    : initial search point
% d    : diretion to search

epsilon = 10^(-5);  % line search tolerance
max = 200;          % maximum number of iterations
alpha_curr = 0;
alpha = 10^(-5);

dphi_zero = feval(grad, x, data)'*d;
dphi_curr = dphi_zero;

i=0;
while abs(dphi_curr) > epsilon * abs(dphi_zero)
  alpha_old = alpha_curr;
  alpha_curr = alpha;
  dphi_old = dphi_curr;
  dphi_curr = feval(grad,x + alpha_curr * d, data)' * d;
  alpha = (dphi_curr*alpha_old-dphi_old*alpha_curr) / (dphi_curr-dphi_old);
  i = i + 1;
  if (i >= max) && (abs(dphi_curr) > epsilon * abs(dphi_zero))
    disp('[EVL] linesearch_secant exceeds maximum number of iterations.');
    break;
  end
end

end % End of 'function linesearch_secant'
