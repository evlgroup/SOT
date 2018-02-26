function [config] = evl_get_default_config()

set(0, 'DefaultTextInterpreter', 'none');

% Common parameters
config.term_max_iter        = 1000;
config.term_tolerance       = 1e-3;

config.debug_verbose        = false;
config.debug_pause          = false;
config.debug_plot           = false;
config.debug_axes_handle    = 0;
config.debug_color          = 'r';

% Gradient descent method, Quasi-Newton method
config.lambda               = 0.1;

% Line search method
config.max_step_size        = 1;
config.shrink_factor        = 0.5;
config.slope_modifier       = 10^-4;

% Trust region method
config.initial_tr_radius    = 1;
config.acceptable_reduction_ratio = 0.1;
config.good_reduction_ratio = 0.9;
config.tr_inc_factor        = 2;
config.tr_dec_factor        = 0.5;

% Quasi-Newton method (BFGS) 
config.B                    = 1;

% Levenberg-Marquardt method
config.initial_damping      = 1;
config.damping_inc_factor   = 2; % Condition: damping_inc_factor > 1
