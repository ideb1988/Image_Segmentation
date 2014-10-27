function idx = KMeansClustering(X, k, centers)
% Run the k-means clustering algorithm.
%
% INPUTS
% X - An array of size m x n containing the points to cluster. Each row is
%     an n-dimensional point, so X(i, :) gives the coordinates of the ith
%     point.
% k - The number of clusters to compute.
% centers - OPTIONAL parameter giving initial centers for the clusters.
%           If provided, centers should be a k x n matrix where
%           centers(c, :) is the center of the cth cluster. If not provided
%           then cluster centers will be initialized by selecting random
%           rows of X. You don't need to use this parameter; it is mainly
%           here to make your code more easily testable.
%
% OUTPUTS
% idx     - The assignments of points to clusters. idx(i) = c means that the
%           point X(i, :) has been assigned to cluster c.

if ~isa(X, 'double')
    X = double(X);
end
m = size(X, 1);
n = size(X, 2);


% If initial cluster centers were not provided then initialize cluster
% centers to random rows of X. Each row of the centers variable should
% contain the center of a cluster, so that centers(c, :) is the center
% of the cth cluster.
if ~exist('centers', 'var')
    centers = zeros(k, n);
    random_number_array = zeros([k 1]);
    % Indranil : take k random Centers
    for i = 1 : k
        random_number = randi(m,1);
        % check for distinct random numbers
        while (any(random_number_array(:,:) == random_number))
            random_number = randi(m,1);
        end
        random_number_array(k,1) = random_number;
        centers(i,:) = X(random_number,:);
    end
end

% The assignments of points to clusters. If idx(i) == c then the point
% X(i, :) belongs to the cth cluster.
idx = zeros(m, 1);

% The number of iterations that we have performed.
iter = 0;

% If the assignments of points to clusters have not converged after
% performing MAX_ITER iterations then we will break and just return the
% current cluster assignments.
MAX_ITER = 100;

while true
    % Store old cluster assignments
    old_idx = idx;
    
    % Compute distances from each point to the centers and assign each
    % point to the closest cluster.
    for i = 1 : m
        min_dist = inf;
        for j = 1 : k
            distance = sqrt(sum((X(i,:) - centers(j,:)) .^ 2)); % EUCLIDEAN DISTANCE
            if (distance < min_dist)
                min_dist = distance;
                idx(i,:) = j;
            end
        end
    end
    
    % Break if cluster assignments didn't change
    if idx == old_idx
        break;
    end
    
    % Update the cluster centers
    % Indranil : get the average of all points in the same cluster and make
    % that the center
    for i = 1 : k
        temp_X = zeros(1,n);
        count = 0;
        for j = 1 : m
            if (idx(j) == i)
                temp_X = temp_X + X(j,:);
                count = count + 1;
            end
            centers(i,:) = temp_X./count;
        end
    end
        
    % Stop early if we have performed more than MAX_ITER iterations
    iter = iter + 1;
    if iter > MAX_ITER
        break;
    end
end
end
