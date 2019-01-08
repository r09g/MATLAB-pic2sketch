% MATLAB CLI version of Picture-to-Sketch Converter
% Author: Raymond Yang
% Reference: https://www.photoshopessentials.com/photo-effects/photo-to-sketch/
% Converts a photo to a colorized sketch
% Input: filename of string type
% Output: 3 color channel image matrix

function imI = convert(filename)
% Prompt user to enter input image filename and read-in image
I = imread(filename);

% Remove image colours and convert from 1 to 3 channels
bwI = rgb2gray(I);
bwI = cat(3, bwI, bwI, bwI); 
% Curve adjust
curI = curving(bwI);
% Invert
invI = 255 - curI;
% min filter
filterI = filter(invI);
% Color dodge blend mode
blendedI = cdblend(filterI,curI);

% Colorize sketch by overlaying original photo on top and adjusting
% transparency
figure('units','normalized','position',[0.2 0.2 0.6 0.6],'visible','off');
plot(1,1);
image(uint8(blendedI));
axis off
axis image
hold on
imcolor = image(I);
hold off
set(imcolor,'AlphaData',0.3);   % transparency
 
% Export colorized sketch
f = getframe;
imI = f.cdata;  % 3 color channel image matrix
end

% Functions----------------------------------------------------------------

% Curving.
% Iterate through pixels and use 40 as threshold
% Set everything below 40 as 0 and scale 40~255 to 0~255
function [curI] = curving(bwI)
    curI = zeros(size(bwI,1),size(bwI,2),size(bwI,3));
    cond = (bwI <= 40);
    curI(cond) = 0;
    curI(~cond) = double(bwI(~cond) - 40) ./ 215 .* 255;
end

% Remove noise in image by finding the local (square region on each
% layer) minimum pixel value and assigning all local pixels that min
% value
% ordfilt2 takes ~2.2 seconds while 3 nested for-loops takes ~21.5 seconds
function [filterI] = filter(invI)
    filterI = zeros(size(invI,1),size(invI,2),size(invI,3));
    for dim = 1:size(filterI,3)
        % the ones matrix size is usually proportional to the image resolutions
        % typically values range from 3~10
        % a greater matrix size means a larger neighbourhood filtering operation takes place
        filterI(:,:,dim) = ordfilt2(invI(:,:,dim),1,ones(5,5));
    end
end

% Color dodge blend mode
% Lighter layer is the base and darker layer is the top
function blendedI = cdblend(filterI,curI)
    blendedI = zeros(size(curI,1),size(curI,2),size(curI,3));
    cond = (curI == 255 );
    blendedI(cond) = 255;
    blendedI(~cond) = min(255,filterI(~cond)./(1 - double(curI(~cond))./255));
    % filter out dark points
    blendedI(blendedI <= 125) = 125;
end
