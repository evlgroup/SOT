function [g] = scan_calc_ndt_gradient(pose, data)

c = cos(pose(3));
s = sin(pose(3));
xy = [c, -s; s, c] * data.xy_query' + repmat(pose(1:2), 1, size(data.xy_query,1));

g = zeros(3, 1);
for i = 1:size(xy,2)
    for index = 1:length(data.ndt_num)
        q = xy(:,i) - data.ndt_mu(index,:)';
        %if (data.ndt_num(index) > 0) && (norm(q) < data.ndt_cellsize)
        if data.ndt_num(index) > 0
            sigma = reshape(data.ndt_sigma(index,:), 2, 2);
            score = exp(-0.5 * q' * sigma^-1 * q);
            dxy = q' * sigma^-1;
            dt = dxy * ([-s, -c; c, -s] * data.xy_query(i,:)');
            g = g + score * [dxy'; dt];
        end
    end
end
