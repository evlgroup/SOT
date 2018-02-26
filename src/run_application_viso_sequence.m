close all;
clear all;

addpath('application');

Rx = @(x)([1, 0, 0; 0, cos(x), -sin(x); 0, sin(x), cos(x)]);
Ry = @(x)([cos(x), 0, sin(x); 0, 1, 0; -sin(x), 0, cos(x)]);
Rz = @(x)([cos(x), -sin(x), 0; sin(x), cos(x), 0; 0, 0, 1]);

input.imagefile = 'data/viso_kitti07/image_0/%06d.png';
input.matchfile = 'data/viso_kitti07/matches_%06d.txt';

% Set the problem, configuration, and initial point
prob = evl_get_empty_problem();
prob.func = @viso_calc_residual;
prob.deriv1st = @viso_calc_jacobian;

prob.data.K = [707.10, 0, 601.89; 0, 707.10, 183.11; 0, 0, 1];
prob.data.baseline = 0.54;

config = evl_get_default_config();
config.term_max_iter = 5;

optimizer = @evl_optimize_gauss_newton;

% Prepare to visualize the result
figure('Color', [1, 1, 1]);
h_imag = axes('Position', [0.05, 0.55, 0.9, 0.40]);
axis off;
h_pose = axes('Position', [0.05, 0.05, 0.9, 0.45]);
axis equal, box on, grid on, hold on;

pose.R = eye(3, 3);
pose.t = zeros(3, 1);
for i = 1:inf
    % Load an image and matched features
    image = imread(sprintf(input.imagefile, i));
    matches = load(sprintf(input.matchfile, i));

    prob.data.xprev = matches(:,1:4);
    prob.data.xcurr = matches(:,5:8);
    disparity = prob.data.xprev(:,1) - prob.data.xprev(:,3);
    prob.data.Xprev = [];
    prob.data.Xprev(:,1) = prob.data.baseline * (prob.data.xprev(:,1) - prob.data.K(1,3)) ./ disparity;
    prob.data.Xprev(:,2) = prob.data.baseline * (prob.data.xprev(:,2) - prob.data.K(2,3)) ./ disparity;
    prob.data.Xprev(:,3) = prob.data.baseline * prob.data.K(1,1) ./ disparity;

    % Optimize the problem, relative 3D pose estimation
    x0 = zeros(6, 1);
    [x, tol] = feval(optimizer, prob, x0, config);
    if sum(isnan(x)) > 0, continue, end
    move.R = (Rz(x(3)) * Ry(x(2)) * Rx(x(1)))';
    move.t = -move.R * [x(4); x(5); x(6)];
    prev.t = pose.t;
    pose.t = pose.R * move.t + pose.t;
    pose.R = pose.R * move.R;

    % Visualize the result
    disp(['[EVL] frame = ', num2str(i), ', pose = ', num2str(pose.t'), ', tol = ', num2str(tol)]);
    axes(h_imag), imshow(image);
    axes(h_pose), line([prev.t(1), pose.t(1)], [prev.t(3), pose.t(3)], 'Color', 'r', 'LineStyle', '-', 'LineWidth', 1, 'Marker', 'x');
    drawnow;
end
