function [axes_handle] = scan_plot_ndt(axes_handle, ndt_mu, ndt_sigma, ndt_num, scale, color, range)

% Check input arguments
if nargin < 5
    scale = 9;
end
if nargin < 6
    color = 'b';
end
if nargin < 7
    range = 10;
end

axes_handle = scan_plot_xy(axes_handle, [0, 0], 'r', range);
hold on;
    for i = 1:length(ndt_num)
        if ndt_num(i) > 0
            h = plot_gaussian_ellipsoid([ndt_mu(i,2); ndt_mu(i,1)], scale * [ndt_sigma(i,4), ndt_sigma(i,3); ndt_sigma(i,2), ndt_sigma(i,1)]);
            set(h, 'LineWidth', 2);
            set(h, 'Color', 'b');
        end
    end
hold off;
