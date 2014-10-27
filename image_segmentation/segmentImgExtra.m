function idx = segmentImgExtra(I, k, weight)
% function idx = segmentImage(img)
% Returns the logical image containing the segment ids obtained from
%   segmenting the input image
%
% INPUTS
% I - The input image contining textured foreground objects to be segmented
%     out.
% k - The number of segments to compute (also the k-means parameter).
%
% OUTPUTS
% idx - The logical image (same dimensions as the input image) contining
%       the segment ids after segmentation. The maximum value of idx is k.
%

% 1. Create your bank of filters using the given alogrithm;
% 2. Compute the filter responses by convolving your input image with
%     each of the num_filters in the bank of filters F.
%     responses(:,:,i)=conv2(I,F(:,:,i),'same')
%     NOTE: we suggest to use 'same' instead of 'full' or 'valid'.
% 3. Remember to take the absolute value of the filter responses (no
%     negative values should be used).
% 4. Construct a matrix X of the points to be clustered, where
%     the rows of X = the total number of pixels in I (rows*cols); and
%     the columns of X = num_filters;
%     i.e. each pixel is transformed into a num_filters-dimensional
%     vector.
% 5. Run kmeans to cluster the pixel features into k clusters,
%     returning a vector IDX of labels.
% 6. Reshape IDX into an image with same dimensionality as I and return
%     the reshaped index image.
%


% PROCESSING OF IMAGE
image = double(rgb2gray(I));
image=image(:,:,1);
s1 = size(image,1);
s2 = size(image,2);

% GET THE BANK OF FILTERS
F = makeLMfilters;
num_filters = size(F, 3);

% Compute the filter responses by convolving your input image with
% each of the num_filters in the bank of filters F.
responses = zeros(s1, s2, num_filters);
for i = 1 : num_filters;
    responses(:,:,i) = conv2(image,F(:,:,i),'same');
end

% Indranil : Get the absolute of responses
responses = abs(responses);

% Construct a matrix X of the points to be clustered, where
% the rows of X = the total number of pixels in I (rows*cols); and
% the columns of X = num_filters;
% i.e. each pixel is transformed into a num_filters-dimensional
% vector.

% Additional for extra credit : colour based idx from
% Convert RGB image to L*a*b*
image_cform = makecform('srgb2lab');
responses_2 = applycform(I,image_cform);
responses_2 = double(responses_2(:,:,2:3));
responses_2 = weight*responses_2;

% Flatten the responses
X = reshape(responses, (s1*s2), num_filters);
X2 = reshape(responses_2, (s1*s2), 2);

% CONCAT THE WEIGHTED COLOR RESPONSES TO THE TEXTURE FILTER RESPONSES
X = horzcat(X,X2);

% Use my own clustering algorithm kmeans
idx = KMeansClustering(X, k);

% Reshape IDX into an image with same dimensionality as I and return
% the reshaped index image.
idx = reshape(idx, s1, s2);

end
