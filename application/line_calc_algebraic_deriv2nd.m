function [deriv2nd] = line_calc_algebraic_deriv2nd(line, points)

x = points(:,1);
N = length(x);

deriv2nd = 2 * [sum(x.^2), sum(x); sum(x), N];
