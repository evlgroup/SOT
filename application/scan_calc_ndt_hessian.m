function [H] = scan_calc_ndt_hessian(pose, data)

c = cos(pose(3));
s = sin(pose(3));
xy = [c, -s; s, c] * data.xy_query' + repmat(pose(1:2), 1, size(data.xy_query,1));

H = zeros(3, 3);
for i = 1:size(xy,2)
    for index = 1:length(data.ndt_num)
        q = xy(:,i) - data.ndt_mu(index,:)';
        %if (data.ndt_num(index) > 0) && (norm(q) < data.ndt_cellsize)
        if data.ndt_num(index) > 0
            sigma = reshape(data.ndt_sigma(index,:), 2, 2);
            sigiv = sigma^-1;
            score = exp(-0.5 * q' * sigiv * q);
            dxy = q' * sigiv;
            vec = [-s, -c; c, -s] * data.xy_query(i,:)';
            dt = dxy * vec;
            Hxx = -dxy(1) * dxy(1) + sigiv(1,1);
            Hxy = -dxy(1) * dxy(2) + sigiv(1,2);
            Hxt = -dxy(1) * dt     + vec' * sigiv(:,1);
            Hyy = -dxy(2) * dxy(2) + sigiv(2,2);
            Hyt = -dxy(2) * dt     + vec' * sigiv(:,2);
            Htt = -dt     * dt     + vec' * sigiv * vec + dxy * [-c, s; -s, -c] * data.xy_query(i,:)';
            H = H + score * [Hxx, Hxy, Hxt; Hxy, Hyy, Hyt; Hxt, Hyt, Htt];
        end
    end
end

% Ensure that 'H' is positive definite
mineig = min(eig(H));
if mineig < 0
    disp('[EVL-App] Hessian is negative definite!');
	%H = H + eye(3,3) * (1 - mineig) * 1.1; Ref. 'ndt_2d.hpp' at Point Cloud Library
    lambda = 1e4;
    H = H + eye(3,3) * (lambda - mineig) * (mineig < 0); % Ref. http://www.mathworks.com/matlabcentral/answers/141886-how-can-i-convert-a-negative-definite-matrix-into-positive-definite-matrix
end
