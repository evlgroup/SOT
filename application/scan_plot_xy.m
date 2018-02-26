function [axes_handle] = scan_plot_xy(axes_handle, xy, color, range)

% Check input arguments
if nargin < 3
    color = 'b';
end
if nargin < 4
    range = 10;
end

% Generate an empty figure if necessary
if isempty(axes_handle) || (axes_handle < 1)
    figure('Color', [1, 1, 1]);
    axis equal;
    xlim([-range, range]);
    ylim([0, range]);
    box on;
    grid on;
    xlabel('Y [m]');
    ylabel('X [m]');
    set(gca, 'XDir', 'reverse');
    axes_handle = gca;
else
    axes(axes_handle);
end

% Draw range data in the rectangular coordinate
line(xy(:,2), xy(:,1), 'Color', color, 'LineStyle', 'none', 'Marker', '+', 'MarkerSize', 2);
