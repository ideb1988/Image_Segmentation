function newImg = transferImg(fgs, idx, sImg, tImg)
% function newimg = transferImg(fgs, idx, sImg, tImg)
%fgs - array of foreground segments e.g [1 2 4 5]
%idx - logical image containing indexes of segments (same size as sImg)
%sImg - source image where object was segmented from (color)
%tImg - target image where object will be transferred (color)

%First crop sImg and idx to remove border problems
[rows, cols,~]=size(sImg);
sImg2= sImg(25:rows-25,25:cols-25,:);
idx2 = idx(25:rows-25,25:cols-25);

%These implementations are somewhat hardcoded to match
% the images selected for the class assignment. You can
% do more clever things with the resizing before transfer
sImg2 = imresize(sImg2, 0.5, 'nearest');
idx2 = imresize(idx2, 0.5, 'nearest');

% Indranil : Calculate the no of pixels in the borders of each segment
no_of_1_in_border = zeros(size(fgs));
for i=1:length(fgs)
   no_of_1_in_border(i) = no_in_borders(idx2,fgs(i)); 
end

%Then create a mask of sImg with foreground segments
[rows, cols,~]=size(sImg2);
mask = false(rows, cols);

for i=1:length(fgs)
    % Indranil : Do not take the mask with the highest number of pixels in the border
    if (no_of_1_in_border(i) == max(no_of_1_in_border))
        mask(idx2==fgs(i))=false;
    else
        mask(idx2==fgs(i))=true;
    end
end

%Now embed the initial mask into a new mask that
%is the same size as the target image
[row_t, col_t,~]=size(tImg);
newmask = false(row_t,col_t);
start_r = floor(row_t*.50);
start_c = floor(col_t*.25);
newmask(start_r:start_r+rows-1, start_c:start_c+cols-1) = mask;

%We must also embed the original image to match the new mask
newimg = uint8(zeros(size(tImg)));
newimg(start_r:start_r+rows-1, start_c:start_c+cols-1,:) = sImg2;

for channel = 1:size(tImg, 3)
    sImgChannel = newimg(:, :, channel);
    bgChannel = tImg(:, :, channel);
    bgChannel(newmask) = sImgChannel(newmask);
    tImg(:, :, channel) = bgChannel;
end
newImg = tImg;

end

% Indranil: Calculate the no of pixels in the borders of each segment

function [pixels_in_border] = no_in_borders(idx2,segment)

pixels_in_border = 0;
temp = (idx2==segment);
[m n] = size(temp);

for i = 1:n
    if (temp(1,i) == 1)
        pixels_in_border = pixels_in_border + 1;
    end
    if (temp(m,i) == 1)
        pixels_in_border = pixels_in_border + 1;
    end
end

for i = 1:m
    if (temp(i,1) == 1)
        pixels_in_border = pixels_in_border + 1;
    end
    if (temp(i,n) == 1)
        pixels_in_border = pixels_in_border + 1;
    end
end

end


