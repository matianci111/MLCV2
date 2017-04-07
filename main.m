%img = imread('pictures/len_top.jpg');
img1 = imread('pictures/img1.pgm');
img2 = imread('pictures/img2.pgm');
%%
threshold = 1.2; 
visualise = 1; num_of_strongest_corners = 200;
ANMS = true; % adaptive non-maximal suppression
radius = 10;
%Q1 2a) Harris Point Detector
coords1 = InterestPointDetector(img1, threshold, ANMS, radius);

%%
%Q1 2b) Obtain Descriptor
descriptor1 = getDescriptor(coords1, img1);

%%
%Q1 2a) Harris Point Detector
coords2 = InterestPointDetector(img2, threshold, ANMS, radius);

% visualise
%Q1 2B) Obtain Descriptor
descriptor2 = getDescriptor(coords2, img2);

%Q1 2C) Obtain correspondance
[InterIDX distance] = myKnnsearch(descriptor1, descriptor2);
tmp_size = size(InterIDX, 2);
myones = 1:1:tmp_size;
InterIDX = [InterIDX;myones];
[distance,idx] = sort(distance,'ascend');
IDX = InterIDX(:,idx);
v2INDX = IDX(1,1:4);
v1INDX = IDX(2,1:4);

%Q1 3A) Compute homography matrix
%obtaining two vectors
v1 = coords1(v1INDX,:);
v2 = coords2(v2INDX,:);
h = gethmatrix(v1, v2);
if visualise
    myvisualise(v1, img1, num_of_strongest_corners, 'original corner image 1');
    myvisualise(v2, img2, num_of_strongest_corners, 'original corner image 2');
end
%f1 = estimateFundamentalMatrix(v1, v2);
projectedv2 = hmatrixproject(v1, h);
myvisualise(projectedv2, img2, num_of_strongest_corners, 'Projected coords1 on image 2');
%f2 = getfmatrix(v1, v2);