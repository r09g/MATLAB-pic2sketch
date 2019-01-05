% MATLAB CLI version of Picture-to-Sketch Converter
% Author: Raymond Yang
% Reference: https://www.photoshopessentials.com/photo-effects/photo-to-sketch/
% Converts a photo to a colorized sketch
% Input: filename of string type
% Output: 3 color channel image matrix
function imI = pic2sketch(filename)
% Prompt user to enter input image filename and read-in image
I = imread(filename);
% Remove image colours and convert from 1 to 3 channels
bwI = rgb2gray(I);
bwI = cat(3, bwI, bwI, bwI); 
% Curving & invert colors.
% Iterate through pixels and use 40 as threshold
% Set everything below 40 as 0 and scale 40~255 to 0~255
invI = zeros(size(I,1),size(I,2),size(I,3));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        if I(i,j,1) <= 40
            bwI(i,j,:) = zeros(1,1,3);
        else
            bwI(i,j,:) = double(bwI(i,j,:) - 40) / 215 * 255;
        end
        % Invert colors
        invI(i,j,:) = 255 - bwI(i,j,:);
    end
end
% Remove noise in image by finding the local (square region on each
% layer) minimum pixel value and assigning all local pixels that min
% value
filterI = zeros(size(I,1),size(I,2),size(I,3));
for i = 1:size(filterI,1)-3
    for j = 1:size(filterI,2)-3
        for dim = 1:size(filterI,3)
            % min on local layer of pre-filtered image
            localmin = min(min(invI(i:i+3,j:j+3,dim)));
            % assign min to corresponding local square region on filtered
            % image
            filterI(i:i+3,j:j+3,dim) = ones(4,4) * double(localmin);
        end
    end
end
% Color dodge blend mode
% Lighter layer is the base and darker layer is the top
blendedI = zeros(size(I,1),size(I,2),size(I,3));
for i = 1:size(blendedI,1)
    for j = 1:size(blendedI,2)
        for dim = 1:size(blendedI,3)
            if I(i,j,dim) == 255 
                blendedI(i,j,dim) = 255;
            else
                blendedI(i,j,dim) = min(255,filterI(i,j,dim)/(1 - double(bwI(i,j,dim))/255));
                % adjust darkness 
                if blendedI(i,j,dim) <= 125
                    blendedI(i,j,dim) = 125;
                end
            end
        end
    end
end
% Colorize sketch by overlaying original photo on top and adjusting
% transparency
figure('units','normalized','position',[0.2 0.2 0.6 0.6]);
plot(1,1);
image(uint8(blendedI));
axis off
axis image
hold on
imcolor = image(I);
set(imcolor,'AlphaData',0.3);   % transparency
% Export colorized sketch
f = getframe(gcf);
imI = f.cdata;  % 3 color channel image matrix
