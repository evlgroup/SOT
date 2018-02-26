function [sse] = line_calc_geometric_error(line, points)

a = line(1);
b = line(2);
x = points(:,1);
y = points(:,2);

err = a * x + b - y;
sse = sum(err.^2) / (a * a + 1);
