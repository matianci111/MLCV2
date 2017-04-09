function [patches] = getDescriptor(coords, img, d)
%Q1 Automatic
%2b) Obtain Descriptor
% this function takes pairs of coordinates and returns the 31x31 pixel
% circle-shaped patches around the given coordinates

% ======================================================================
% Alternatively, if we insist to use square-shaped patches around the
% interest points, what we can do is to estimate a dominant orientation.
% Then an oriented patch can be extracted and used to form a feature
% descriptor.

% The simplest orientation estimate is the average gradient within a region
% around the interest point.
% And in order to make this method more reliable, the aggregation window
% (circle-shaped) should be larger than the detecting window.

% Sometimes, however, the averaged (signed) gradient in a region can be
% very small and therefore an unreliable indicator of orientation. A more
% reliable method is to look at the histogram of orientations (e.g.36 bins)
% computed around the interest point.

% Note here, this alternative method is not implemented here.
% ======================================================================

if size(size(img)) == 3
    img = rgb2gray(img);
end
edges = 1:2:256;

% ================ circle mask =====================
if mod(d,2)==0 % size of patch is even
    diameter = d+1;
else % size of patch is odd
    diameter = d;
end
mask = zeros(diameter,diameter);
for y=1:diameter
    for x=1:diameter
        dx = x - diameter/2;
        dy = y - diameter/2;
        r2 = dx*dx + dy*dy;
        if r2 <= (diameter/2)^2
            mask(y,x) = 1;
        end
    end
end

% ========== get all descriptor patches ===========
for i=1:size(coords, 1)
    radius = floor(diameter/2);
    patch = img(coords(i,1)-radius:coords(i,1)+radius,...
            coords(i,2)-radius:coords(i,2)+radius);
    patch = patch.*uint8(mask); % circle patch
    N = histcounts(patch, edges);
    patches(i,:) = N(1,:);
end