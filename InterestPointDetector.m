function [coords] = InterestPointDetector(img, threshold)
%Q1 Automatic
%2a) Harris Point Detector

G = rgb2gray(img);
img = im2double(G);

dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
dy = dx';

row1 = [0.03 0.105 0.222 0.286 0.222 0.105 0.03];
fx = repmat(row1, 7, 1);
fy = fx';
g = fx.*fy;
    
Ix = conv2(img, dx, 'same');    % Image derivatives
Iy = conv2(img, dy, 'same');    
    
Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');

cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps); % Harris corner measure

% Extract local maxima by performing a grey scale morphological
% dilation and then finding points in the corner strength image that
% match the dilated image and are also greater than the threshold.
sze = 2*1+1;                   % Size of mask.
mx = ordfilt2(cim,sze^2,ones(sze)); % Grey-scale dilate.
cim = (cim==mx)&(cim>threshold);       % Find maxima.

[r,c] = find(cim);                  % Find row,col coords.
%figure, imagesc(img), axis image, colormap(gray), hold on
%plot(c,r,'ys'), title('corners detected');
coords = [r c];