% This function derives histogram of target (or tracked) object
% based on the ranks in image.
% Note: we give higher weight to the pixels nearer to the central point.

function [bins, num_bins] = get_histogram(X,Y,hx,hy,im,image_X,image_Y)

x1 = X - hx;
x2 = X + hx;
y1 = Y - hy;
y2 = Y + hy;

% Deal with boundary condition
if (x1 <= 0)
    x1 = 1;
    x2 = 1 + 2 * hx;
end
if (x2 > image_X)
    x1 = image_X - 2 * hx;
    x2 = image_X;
end
if (y1 <= 0)
    y1 = 1;
    y2 = 1 + 2 * hy;
end
if (y2 > image_Y)
    y1 = image_Y - 2 * hy;
    y2 = image_Y;
end

% Get target area
target_area = im(y1:y2,x1:x2);
% Extract Histogram of Gradient
[hog, ~] = extractHOGFeatures(target_area,'CellSize',[10 10]);

% Normalize HoG
sum_hog = sum(hog);
bins = hog ./ sum_hog;
num_bins = length(bins);

