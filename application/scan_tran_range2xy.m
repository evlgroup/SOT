function [rect] = scan_tran_range2xy(beam_data, beam_start, beam_end)

% Check input arguments
if nargin < 2
    beam_start = -pi / 2;
end
if nargin < 3
    beam_end = beam_start + pi;
end

% Transform range data from polar to rectangular coordinate
phi = linspace(beam_start, beam_end, length(beam_data))';
rect(:,1) = beam_data' .* cos(phi);
rect(:,2) = beam_data' .* sin(phi);
