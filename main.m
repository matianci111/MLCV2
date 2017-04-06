%img = imread('pictures/len_top.jpg');
img1 = imread('pictures/scene1.ppm');
img2 = imread('pictures/scene2.ppm');
threshold = 0.08;
%Q1 2a) Harris Point Detector
coords1 = InterestPointDetector(img1, threshold);

%Q1 2b) Obtain Descriptor
descriptor1 = getDescriptor(coords1, img1);

%Q1 2a) Harris Point Detector
coords2 = InterestPointDetector(img2, threshold);

%Q1 2B) Obtain Descriptor
descriptor2 = getDescriptor(coords2, img2);

%Q1 2C) Obtain correspondance
[IDX distance] = myKnnsearch(descriptor1, descriptor2);

%Q1 3A) Compute homography matrix
%obtaining two vectors
v1 = coords1;
v2 = coords2(IDX,:);
h = gethmatrix(v1, v2);
f1 = estimateFundamentalMatrix(v1, v2);
projectedv2 = hmatrixproject(v2, h);
figure, imagesc(img1), axis image, colormap(gray), hold on
plot(projectedv2(:,1),projectedv2(:,2),'ys'), title('corners detected');
%f2 = getfmatrix(v1, v2);