function [line] = line_estimate_2point(points)

if size(points,1) < 2
    error('[EVL-Line] The number of points should be at least 2.');
end
if size(points,2) < 2
    error('[EVL-Line] The given points should be an n-by-2 matrix.');
end

a = (points(2,2) - points(1,2)) / (points(2,1) - points(1,1));
b = points(1,2) - a * points(1,1);
line = [a; b];
