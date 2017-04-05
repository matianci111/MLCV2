img = imread('pictures/len_top.jpg');
%Q1 2a) Harris Point Detector
coords = InterestPointDetector(img, 0.01);

%Q1 2b) Obtain Descriptor
descriptor = getDescriptor(coords, img);
