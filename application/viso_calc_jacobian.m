function [J] = viso_calc_jacobian(pose, data)

Rx   = @(x)([1, 0, 0; 0, cos(x), -sin(x); 0, sin(x), cos(x)]);
Rxdx = @(x)([1, 0, 0; 0, -sin(x), -cos(x); 0, cos(x), -sin(x)]);
Ry   = @(x)([cos(x), 0, sin(x); 0, 1, 0; -sin(x), 0, cos(x)]);
Rydy = @(x)([-sin(x), 0, cos(x); 0, 1, 0; -cos(x), 0, -sin(x)]);
Rz   = @(x)([cos(x), -sin(x), 0; sin(x), cos(x), 0; 0, 0, 1]);
Rzdz = @(x)([-sin(x), -cos(x), 0; cos(x), -sin(x), 0; 0, 0, 1]);

R = Rz(pose(3))  * Ry(pose(2))  * Rx(pose(1));
t = pose(4:6);

Rdx = Rz(pose(3))   * Ry(pose(2))   * Rxdx(pose(1));
Rdy = Rz(pose(3))   * Rydy(pose(2)) * Rx(pose(1));
Rdz = Rzdz(pose(3)) * Ry(pose(2))   * Rx(pose(1));

n = size(data.xcurr,1);
J = zeros(4 * n, 6);
for i = 1:n
    Xl = data.Xprev(i,:)';
    Xr = Xl - [data.baseline; 0; 0];
    pl = data.K * (R * Xl + t);
    pr = data.K * (R * Xr + t);

    pldp = data.K * [Rdx * Xl, Rdy * Xl, Rdz * Xl, eye(3,3)];
    prdp = data.K * [Rdx * Xr, Rdy * Xr, Rdz * Xr, eye(3,3)];

    J(4*i+1,:) = (pl(1,:) .* pldp(3,:) - pldp(1,:) .* pl(3,:)) ./ (pl(3,:)).^2; % Left u's Jacobian
    J(4*i+2,:) = (pl(2,:) .* pldp(3,:) - pldp(2,:) .* pl(3,:)) ./ (pl(3,:)).^2; % Left v's Jacobian
    J(4*i+3,:) = (pr(1,:) .* prdp(3,:) - prdp(1,:) .* pr(3,:)) ./ (pr(3,:)).^2; % Right u's Jacobian
    J(4*i+4,:) = (pr(2,:) .* prdp(3,:) - prdp(2,:) .* pr(3,:)) ./ (pr(3,:)).^2; % Right v's Jacobian
end
