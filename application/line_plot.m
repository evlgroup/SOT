function [axes_handle] = line_plot(axes_handle, model, color, range, data)

% Check input arguments
if nargin < 3
    color = 'r';
end
if nargin < 4
    range = [0, 600; 0, 400];
end
if nargin < 5
    data = [];
end

% Generate an empty figure if necessary
if isempty(axes_handle) || (axes_handle < 1)
    figure('Color', [1, 1, 1]);
    line(data(:,1), data(:,2), 'Color', 'b', 'LineStyle', 'none', 'Marker', '.');
    xlim(range(1,:));
    ylim(range(2,:));
    box on;
    grid on;
    xlabel('X');
    ylabel('Y');
    axes_handle = gca;
else
    axes(axes_handle);
end

% Draw the given line
x = range(1,:);
y = model(1) * x + model(2);
line(x, y, 'Color', color, 'LineWidth', 2);
