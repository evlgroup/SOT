function [r] = viso_calc_residual(pose, data)

Rx = @(x)([1, 0, 0; 0, cos(x), -sin(x); 0, sin(x), cos(x)]);
Ry = @(x)([cos(x), 0, sin(x); 0, 1, 0; -sin(x), 0, cos(x)]);
Rz = @(x)([cos(x), -sin(x), 0; sin(x), cos(x), 0; 0, 0, 1]);

R = Rz(pose(3)) * Ry(pose(2)) * Rx(pose(1));
t = pose(4:6);

n = size(data.xcurr,1);
r = zeros(4 * n, 1);
for i = 1:n
    Xl = data.Xprev(i,:)';
    Xr = Xl - [data.baseline; 0; 0];
    pl = data.K * (R * Xl + t);
    pr = data.K * (R * Xr + t);

    r(4*i+[1:2]) = data.xcurr(i,1:2)' - pl(1:2) ./ pl(3); % Left projection error
    r(4*i+[3:4]) = data.xcurr(i,3:4)' - pr(1:2) ./ pr(3); % Right projection error
end
