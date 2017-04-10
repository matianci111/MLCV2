% SIFT
%% parameters to be adjusted
knn_threshold = 1.15;
visualise = 1;
%% read image
%img = imread('pictures/len_top.jpg');
img1 = imread('pictures/img1.pgm');
img2 = imread('pictures/img3.pgm');
run('vlfeat-0.9.18/toolbox/vl_setup.m'); % vlfeat library
cd('libsvm-3.18/matlab'); % libsvm library
run('make');
cd('../..');

% ================= convert colour scale to gray scale =================
% img 1
if (size(size(img1),2) == 3)
    img1 = rgb2gray(img1);
end
img1 = im2double(img1);
% img 2
if (size(size(img2),2) == 3)
    img2 = rgb2gray(img2);
end
img2 = im2double(img2);


%% extract interest points & their descriptors
PHOW_Sizes = 32;%4:2:30; % Multi-resolution, these values determine the scale of each layer.
PHOW_Step = 32; % The lower the denser. Select from {2,4,8,16}

% ========= extracts PHOW features (multi-scaled Dense SIFT) ========= 
% image 1
[frames1, descriptor1_sift] = vl_phow(single(img1),'Sizes',PHOW_Sizes,'Step',PHOW_Step); 
coords1_sift = vertcat(frames1(2,:),frames1(1,:))'; 
% image 2
[frames2, descriptor2_sift] = vl_phow(single(img2),'Sizes',PHOW_Sizes,'Step',PHOW_Step); 
coords2_sift = vertcat(frames2(2,:),frames2(1,:))';
if visualise
    figure;
    subplot(2,2,1);
    myvisualise(coords1_sift, img1, 'very original corner image 1');
    subplot(2,2,2);
    myvisualise(coords2_sift, img2, 'very original corner image 2');
end

%% Obtain correspondance
[idx_matchedIP_img2_raw_sift, distance_sift] = myKnnsearch(descriptor1_sift',descriptor2_sift',knn_threshold);
[distance_sift,idx_sift] = sort(distance_sift,'ascend');
matchedIP_idx_sift = idx_sift(~isinf(distance_sift)); % the index of matched interest points

idx_matchedIP_img1_raw_sift = 1:1:size(idx_matchedIP_img2_raw_sift,2);
idx_matchedIP_img1_sift = idx_matchedIP_img1_raw_sift(matchedIP_idx_sift);
idx_matchedIP_img2_sift = idx_matchedIP_img2_raw_sift(matchedIP_idx_sift);

% remove correspondance that are not unique (which are ambiguous)
if knn_threshold ~= 1
    arr1 = getNonRepeatableElementIdx(idx_matchedIP_img1_sift);
    arr2 = getNonRepeatableElementIdx(idx_matchedIP_img2_sift);
    idx_sift = intersect(arr1,arr2);
    correspondance_sift = [idx_matchedIP_img1_sift(idx_sift);idx_matchedIP_img2_sift(idx_sift)];
    if size(correspondance_sift,2)==0
       error('user defined error - no interest point is matched under current parameters'); 
    end
else
    correspondance_sift = [idx_matchedIP_img1_sift;idx_matchedIP_img2_sift];
end

%% Compute homography matrix
% ========== Q1 3A) ==========  

% obtaining two vectors
v1 = coords1_sift(correspondance_sift(1,:),:);
v2 = coords2_sift(correspondance_sift(2,:),:);
h = gethmatrix(v1, v2);
if visualise
    figure;
    subplot(2,2,1);
    myvisualise(v1, img1, 'original corner image 1');
    subplot(2,2,2);
    myvisualise(v2, img2, 'original corner image 2');
end
%f1 = estimateFundamentalMatrix(v1, v2);
projectedv2 = hmatrixproject(v1, h);
if visualise
    subplot(2,2,[3 4]);
    myvisualise(projectedv2, img2, 'Projected coords1 on image 2');
    
    % super title displaying the values of used parameters 
    print_knnThre = sprintf('\n knn threshold for rejecting ambiguous matchings = %f',knn_threshold);
    suptitle_print_msg = strcat(print_knnThre);
    suptitle(suptitle_print_msg);

end