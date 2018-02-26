function [ndt_mu, ndt_sigma, ndt_num] = scan_tran_xy2ndt(xy, ndt_cellsize, ndt_maxrange, ndt_mindata, ndt_mineig)

% Check input arguments
if nargin < 2
    ndt_cellsize = 1;
end
if nargin < 3
    ndt_maxrange = 10;
end
if nargin < 4
    ndt_mindata = 3;
end
if nargin < 5
    ndt_mineig = 0.01;
end

% Prepare output
n = ceil(ndt_maxrange / ndt_cellsize);
ndt_mu    = zeros(2 * n * n, 2);
ndt_sigma = zeros(2 * n * n, 4);
ndt_num   = zeros(2 * n * n, 1);
ndt_index = reshape(1:(2 * n * n), n, 2 * n); % Format: ndt_index(x, y) = n * (y - 1) + x

% Perform Normal Distribution Transform (NDT)
indxy = floor(xy / ndt_cellsize) + 1;
indxy(:,2) = indxy(:,2) + n;
for i = 1:size(xy,1)
    if (indxy(i,1) < 1) || (indxy(i,2) < 1) || (indxy(i,1) > n) || (indxy(i,2) > 2 * n), continue, end
    index = ndt_index(indxy(i,1), indxy(i,2));
    ndt_mu(index,:)    = ndt_mu(index,:) + xy(i,:);
    ndt_sigma(index,:) = ndt_sigma(index,:) + reshape([xy(i,:)' * xy(i,:)], 1, 4);
    ndt_num(index)     = ndt_num(index) + 1;
end
for i = 1:length(ndt_num)
    if ndt_num(i) > ndt_mindata
        ndt_mu(i,:) = ndt_mu(i,:) / ndt_num(i);
        covar = reshape(ndt_sigma(i,:), 2, 2) / ndt_num(i) - ndt_mu(i,:)' * ndt_mu(i,:);
        [V, D] = eig(covar);
        if D(1,1) < ndt_mineig * D(2,2) % Check too small eigen value
            D(1,1) = ndt_mineig * D(2,2);
            covar = V * D * V';
        end
        ndt_sigma(i,:) = reshape(covar, 1, 4);
    else
        ndt_mu(i,:)    = 0;
        ndt_sigma(i,:) = 0;
        ndt_num(i,:)   = 0;
    end
end

% Remove empty cells
ndt_mu = ndt_mu(ndt_num > 0,:);
ndt_sigma = ndt_sigma(ndt_num > 0,:);
ndt_num = ndt_num(ndt_num > 0,:);
