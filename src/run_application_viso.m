close all;
clear all;

addpath('application');

Rx = @(x)([1, 0, 0; 0, cos(x), -sin(x); 0, sin(x), cos(x)]);
Ry = @(x)([cos(x), 0, sin(x); 0, 1, 0; -sin(x), 0, cos(x)]);
Rz = @(x)([cos(x), -sin(x), 0; sin(x), cos(x), 0; 0, 0, 1]);

% Load an image and matched features
matches = load('data/viso_kitti07_000001.txt');
image = imread('data/viso_kitti07_000001.png');

% Set the problem, configuration, and initial point
prob = evl_get_empty_problem();
prob.func = @viso_calc_residual;
prob.deriv1st = @viso_calc_jacobian;

prob.data.K = [707.10, 0, 601.89; 0, 707.10, 183.11; 0, 0, 1];
prob.data.baseline = 0.54;
prob.data.xprev = matches(:,1:4);
prob.data.xcurr = matches(:,5:8);
disparity = prob.data.xprev(:,1) - prob.data.xprev(:,3);
prob.data.Xprev(:,1) = prob.data.baseline * (prob.data.xprev(:,1) - prob.data.K(1,3)) ./ disparity;
prob.data.Xprev(:,2) = prob.data.baseline * (prob.data.xprev(:,2) - prob.data.K(2,3)) ./ disparity;
prob.data.Xprev(:,3) = prob.data.baseline * prob.data.K(1,1) ./ disparity;

config = evl_get_default_config();

x0 = zeros(6, 1);

optimizer = @evl_optimize_gauss_newton;

% Prepare to visualize the result
xproj = prob.data.K * prob.data.Xprev';
xproj = xproj ./ repmat(xproj(3,:), 3, 1);
h_proj = viso_plot_data(0, prob.data.xcurr, xproj', image);
pause;

% Optimize the problem with the given initial point
max_iter = config.term_max_iter;
config.term_max_iter = 1;
for itr = 1:max_iter
    % Optimize the problem, relative 3D pose estimation
    [x, tol] = feval(optimizer, prob, x0, config);

    % Visualize the result
    R = Rz(x(3)) * Ry(x(2)) * Rx(x(1));
    t = [x(4); x(5); x(6)];
    xproj = prob.data.K * (R * prob.data.Xprev' + repmat(t, 1, size(prob.data.Xprev,1)));
    xproj = xproj ./ repmat(xproj(3,:), 3, 1);
    viso_plot_data(h_proj, prob.data.xcurr, xproj', image);
    disp(['[EVL] iter = ', num2str(itr), ', x = ', num2str(x'), ', tol = ', num2str(tol)]);

    % Prepare the next optimization
    x0 = x;
    pause;
end
