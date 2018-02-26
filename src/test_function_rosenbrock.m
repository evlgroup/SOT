function [f, fp, fpp] = test_function_rosenbrock()
%TEST_FUNCTION_ROSENBROCK Rosenbrock test function and its derivatives
%
%   Note: Minimum is at f(1,1) = 0 in case of n = 2
%
%   Reference:
%       Test functions for optimization (Wikipedia), https://en.wikipedia.org/wiki/Test_functions_for_optimization

f   = @(x,data) (100*(x(2) - x(1).^2).^2 + (1 - x(1)).^2);
fp  = @(x,data) ([-400*x(1)*x(2) + 400*x(1)^3 + 2*x(1) - 2 ; 200*x(2) - 200*x(1)^2]);
fpp = @(x,data) ([-400*x(2) + 1200*x(1)^2+2, -400*x(1) ; -400*x(1), 200]);
