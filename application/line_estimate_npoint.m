function [line] = line_estimate_npoint(points)

if size(points,1) < 2
    error('[EVL-Line] The number of points should be at least 2.');
end
if size(points,2) < 2
    error('[EVL-Line] The given points should be an n-by-2 matrix.');
end

A = [points(:,1), ones(size(points,1),1)];
b = points(:,2);
line = pinv(A) * b;
