%img = imread('pictures/len_top.jpg');
img1 = imread('pictures/img1.pgm');
img2 = imread('pictures/img2.pgm');
%%
threshold = 0.4; 
visualise = 1; num_of_strongest_corners = 200;
ANMS = true; % adaptive non-maximal suppression
radius = 10;
%Q1 2a) Harris Point Detector
coords1 = InterestPointDetector(img1, threshold, ANMS, radius);

% visualise
if visualise
    show_corner = [];
    num_of_corners=size(coords1,1);
    if num_of_corners > num_of_strongest_corners %the number of corners
        figure, imagesc(img1), axis image, colormap(gray), hold on
        plot(coords1(1:num_of_strongest_corners,2),coords1(1:num_of_strongest_corners,1),'ys'), title('corners detected');
    else
        loop_size=num_of_corners;
        figure, imagesc(img1), axis image, colormap(gray), hold on
        plot(coords1(:,2),coords1(:,1),'ys'), title('corners detected');
    end
    
end
%%
%Q1 2b) Obtain Descriptor
descriptor1 = getDescriptor(coords1, img1);

%%
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