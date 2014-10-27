% The runfile for ASSIGNMENT 2
% Indranil Deb 50097062

function [] = runfile(~)

extracredit = true; % set false to use segmentImg, true uses segmentImgExtra

% PLEASE SET WEIGHT TO 2 for the cheetah, 20 for gecko and 5 for the others
weight = 20;
% READ IN THE IMAGE TO BE INSERTED
foreground_from_image = 'gecko.jpg';
% READ IN THE BACKGROUND
background_image = 'bg2.jpg';
% SET THE VALUE OF k
k = 2;

% CHANGE TO THE IMAGES FOLDER
main = cd('images');
sImg = imread(foreground_from_image);
tImg = imread(background_image);
% RETURN TO MAIN FOLDER
cd(main);

% SET FGS TO ALL POSSIBLE SEGMENTS (WE WILL CALCULATE THE FOREGROUND
% SEGMENTS IN transferImg FUNCTION
fgs = linspace(1,k,k);

% CALCULATE idx
if (extracredit == false)
    idx = segmentImg(sImg, k);
else
    idx = segmentImgExtra(sImg, k, weight);
end
    
% USE THE transferImg FUNCTION TO GET THE FINAL OUTPUT
newImg = transferImg(fgs, idx, sImg, tImg);

% SHOW THE FINAL OUTPUT
figure, imshow(newImg);
end