function [f, fp, fpp] = test_function_x4()
%TEST_FUNCTION_X4 Simple biquadratic test function and its derivatives
%
%   Note: Minimum is at f(0) = 0

f   = @(x, data) (x.^4);
fp  = @(x, data) (4*x.^3);
fpp = @(x, data) (12*x.^2);
