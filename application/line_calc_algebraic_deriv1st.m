function [deriv1st] = line_calc_algebraic_deriv1st(line, points)

a = line(1);
b = line(2);
x = points(:,1);
y = points(:,2);

err = a * x + b - y;
deriv1st = 2 * [sum(err .* x); sum(err)];
