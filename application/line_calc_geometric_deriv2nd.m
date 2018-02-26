function [deriv2nd] = line_calc_geometric_deriv2nd(line, points)

a = line(1);
b = line(2);
x = points(:,1);
y = points(:,2);
N = length(x);

err = a * x + b - y;
den = a * a + 1;
buf = x - a * (b - y);

aa = sum(x .* buf - (b - y) .* err - (4 * a * buf .* err) / den) / den^2;
ab = sum(x - a * (err + b - y)) / den^2;
bb = N / den;

deriv2nd = 2 * [aa, ab; ab, bb];
