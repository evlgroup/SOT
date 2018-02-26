function [axes_handle] = evl_plot_x(axes_handle, prob, x, col, x_prev, col_prev, linewidth, marker, markersize)
%EVL_PLOT_X Plot the given points and return its axes handle
%
%   axes_handle = EVL_PLOT_X(axes_handle, prob, x, col, x_prev, col_prev)
%       (handle) axes_handle: the axes handle to draw the given point
%                             ([] or 0 will generate a new figure.)
%       (struct) prob       : the problem definition (See 'help evl_get_empty_problem')
%       (vector) x          : the current point (Nx1 matrix)
%       (color)  col        : color for the current point (e.g. 'r' or [1, 0, 0] for red)
%       (vector) x_prev     : the previous point (Nx1 matrix, optional)
%       (color)  col_prev   : color for the previous point (optional)
%
%   Note: 'prob.func' should be defined in advance if N == 1.
%
%   Example:
%       prob.func = @(x, data)(norm(x));
%       x = [10; 18];
%       x_prev = [3; 29];
%       evl_plot_x(0, prob, x, 'r', x_prev, 'g');

if nargin < 4
    col = 'r';
end
if nargin < 6
    col_prev = 'g';
end
if nargin < 7
    linewidth = 4;
end
if nargin < 8
    marker = '+';
end
if nargin < 9
    markersize = 5;
end

% Generate an empty figure if necessary
if isempty(axes_handle) || (axes_handle < 1)
    figure('Color', [1, 1, 1]);
    axes_handle = gca;
else
    axes(axes_handle);
end

if length(x) < 2
    % In case of the 1-dimensional function
    cost = feval(prob.func, x, prob.data);
    if nargin > 4
        cost_prev = feval(prob.func, x_prev, prob.data);
        line(x_prev, cost_prev, 'Color', col_prev, 'Marker', marker, 'LineWidth', linewidth, 'MarkerSize', markersize);
        line([x_prev, x], [cost_prev, cost], 'Color', col_prev);
    end
    line(x, cost, 'Color', col, 'Marker', marker, 'LineWidth', linewidth, 'MarkerSize', markersize);
else
    % In case of the 2-dimensional function (and more)
    if nargin > 4
        line(x_prev(1), x_prev(2), 'Color', col_prev, 'Marker', marker, 'LineWidth', linewidth, 'MarkerSize', markersize);
        line([x_prev(1), x(1)], [x_prev(2), x(2)], 'Color', col_prev);
    end
    line(x(1), x(2), 'Color', col, 'Marker', marker, 'LineWidth', linewidth, 'MarkerSize', markersize);
end
