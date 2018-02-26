function [data] = scan_load_clf(filename, filter, spec)

% Check input arguments
if nargin < 2
    filter = 'FLASER';
end
if nargin < 3
    spec.beam_start = -pi / 2;
    spec.beam_end   = pi / 2;
end

% Read the given CLF file and extract laser data
fid = fopen(filename, 'r');
raw = [];
while true
    textline = fgetl(fid);
    if ~ischar(textline), break, end
    if ~isequal(textline(1:length(filter)), filter), continue, end

    textline(isletter(textline)) = ' ';
    raw = [raw; str2num(textline)];
end
fclose(fid);

% Arrange laser data
% - Carmen Log File format for laser data
% - # FLASER num_readings [range_readings] x y theta odom_x odom_y odom_theta
data.beam_start = spec.beam_start;
data.beam_end   = spec.beam_end;
data.beam_n     = raw(1,1);
data.beam_data  = raw(:,2:2+data.beam_n-1);
data.odom       = raw(:,2+data.beam_n:2+data.beam_n+3-1);
data.timestamp  = raw(:,end);
