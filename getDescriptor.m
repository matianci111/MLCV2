function [patches] = getDescriptor(coords, img)
%Q1 Automatic
%2b) Obtain Descriptor
%this function takes pairs of coordinates and returns the 31x31 pixel
%patches around the given coordinates
if size(size(img)) == 3
    img = rgb2gray(img);
end
edges = 1:2:256;
for i=1:size(coords, 1)
    patch = img(coords(i,1)-15:coords(i,1)+15,coords(i,2)-15:coords(i,2)+15);
    N = histcounts(patch, edges, 'Normalization', 'probability');
    patches(i,:) = N(1,:);
end