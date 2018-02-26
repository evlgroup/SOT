function [axes_handle] = scan_plot(axes_handle, xcurr, xprev, image, threshold)

% Check input arguments
if nargin < 3
    xprev = xcurr;
end
if nargin < 4
    image = [];
end
if nargin < 5
    threshold = 2;
end

% Generate an empty figure if necessary
if isempty(axes_handle) || (axes_handle < 1)
    figure('Color', [1, 1, 1]);
    set(gca, 'Unit', 'normalized', 'Position', [0 0 1 1]);
    axes_handle = gca;
else
    axes(axes_handle);
end
cla();

% Draw an image if given
if ~isempty(image)
    imagesc(image);
    if size(image,3) < 3
        colormap('gray');
    end
    axis equal off;
    xlim([1, size(image,2)]);
    ylim([1, size(image,1)]);
end

% Draw matched features
for i = 1:size(xcurr,1)
    delta = min(norm(xcurr(i,1:2) - xprev(i,1:2)) / threshold, 1);
    color = [delta, 0, 1 - delta];
    line([xprev(i,1), xcurr(i,1)], [xprev(i,2), xcurr(i,2)], 'Color', color);
    line(xcurr(i,1), xcurr(i,2), 'Color', color, 'LineStyle', 'none', 'Marker', '+', 'MarkerSize', 2);
end
