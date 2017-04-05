function [coords] = InterestPointDetector(img, threshold)
%Q1 Automatic
%2a) Harris Point Detector
maxheight = size(img, 1);
maxwidth = size(img, 2);
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
coords = [c r];
%code from below removes all the corners that are within 32 pixels from the
%edges of the image, this is done so that in Q1,2b patches of 32x32 can be
%obtained with meaningful data
index = [];
for i = 1:size(coords, 1)
    if~(coords(i,1)>32 && coords(i,2)>32 && coords(i,1)<maxwidth - 32 && coords(i,2)<maxheight - 32)
        index(end+1) = i;
    end
end
coords(index,:)=[];
%figure, imagesc(img), axis image, colormap(gray), hold on
%plot(coords(:,1),coords(:,2),'ys'), title('corners detected');