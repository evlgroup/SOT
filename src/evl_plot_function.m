function [axes_handle] = evl_plot_function(axes_handle, prob, range, steps, labels)
%EVL_PLOT_FUNCTION Prepare plot to display results
%
%   [axes_handle] = evl_plot_function(axes_handle, prob, range, steps, labels)
%       [handle] axes_handle : axes handle of current plot (out)
%       (handle) axes_handle : selecting current axes or specific axes handle
%       (struct) prob        : the problem definition (See 'help evl_get_empty_problem')
%       (matrix) range       : definition of plot range(e.g. [-1,1:-1,1]
%       (value)  steps       : definition of plot steps
%       (string cell) labels : definition of plot lables (e.g. {'x', 'y', 'z'} )
%
%   Example:
%       prob = evl_get_empty_problem();
% 	    h = evl_plot_function(0, prob, [-1, 1; -1, 1], 100, {'x label', 'y label'});

% Check input arguments
if nargin < 4
    steps = 100;
end

% Generate an empty figure if necessary
if isempty(axes_handle) || (axes_handle < 1)
    figure('Color', [1, 1, 1]);
    axes_handle = gca;
else
    axes(axes_handle);
    cla;
end
hold on;

if size(range,1) < 2
    % In case of the 1-dimensional function
    % Calculate each value of the given function within the given range
    axis auto;
    xrange = linspace(range(1), range(2), steps);
    yvalue = zeros(size(xrange));
    for xx = 1:length(xrange)
        yvalue(xx) = feval(prob.func, xrange(xx), prob.data);
    end

    % Draw the shape of 'prob.func'
    plot(xrange, yvalue, 'b-', 'LineWidth', 2);
    box on;
    grid on;
else
    axis auto;
    % In case of the 2-dimensional function (and more)
    if size(range,1) > 2
        warning('[EVL] Ranges more than 2 dimensions are ignored.');
        test = mean(range,2);
    end

    % Calculate each value of the given function within the given range
    xrange = linspace(range(1,1), range(1,2), steps);
    yrange = linspace(range(2,1), range(2,2), steps);
    [xmesh, ymesh] = meshgrid(xrange, yrange);
    Zmesh = zeros(size(xmesh));
    for yy = 1:size(Zmesh,1)
        for xx = 1:size(Zmesh,2)
            test(1) = xmesh(yy,xx);
            test(2) = ymesh(yy,xx);
            Zmesh(yy,xx) = feval(prob.func, test, prob.data);
        end
    end

    % Draw the shape of 'prob.func'
    contourf(xmesh, ymesh, Zmesh, steps);
    box on;
end

% Draw x-, y-, and z-axis labels if given
if nargin > 4
    if length(labels) > 0, xlabel(labels{1}), end
    if length(labels) > 1, ylabel(labels{2}), end
    if length(labels) > 2, zlabel(labels{3}), end
end
hold off;
