function [f, fp, fpp] = test_function_matyas()
%TEST_FUNCTION_MATYAS Matyas test function and its derivatives
%
%   Note: Minimum is at f(0,0) = 0
%
%   Reference:
%       Test functions for optimization (Wikipedia), https://en.wikipedia.org/wiki/Test_functions_for_optimization

f   = @(x, data) (0.26*(x(1).^2 + x(2).^2) - 0.48*x(1)*x(2));
fp  = @(x, data) ([0.52*x(1) - 0.48*x(2) ; 0.52*x(2) - 0.48*x(1)]);
fpp = @(x, data) ([0.52, -0.48; -0.48, 0.52]);
