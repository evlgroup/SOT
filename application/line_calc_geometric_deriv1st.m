function [deriv1st] = line_calc_geometric_deriv1st(line, points)

a = line(1);
b = line(2);
x = points(:,1);
y = points(:,2);

err = a * x + b - y;
den = a * a + 1;
deriv1st = 2 * [sum(err .* (x - a * (b - y))) / den^2; sum(err) / den];
