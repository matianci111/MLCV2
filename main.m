%img = imread('pictures/len_top.jpg');
img1 = imread('pictures/scene1.ppm');
img2 = imread('pictures/scene5.ppm');
%% paramaters that can be adjusted
threshold = 0; 
visualise = 1;
knn_threshold = 1.2;
ANMS = true; % adaptive non-maximal suppression
radius = 10;

%% image 1
%Q1 2a) image 1 - Harris Point Detector
coords1 = InterestPointDetector(img1, threshold, ANMS, radius);

%Q1 2b) image 1 - Obtain Descriptor
Descriptor_length = 32;
descriptor1 = getDescriptor(coords1, img1, Descriptor_length);

%% image 2
%Q1 2a) image 2 - Harris Point Detector
coords2 = InterestPointDetector(img2, threshold, ANMS, radius);
%Q1 2B) image 2 - Obtain Descriptor
Descriptor_length = 32;
descriptor2 = getDescriptor(coords2, img2, Descriptor_length);

%% obtain correspondance
% ========== Q1 2C) ========== 
[idx_matchedIP_img2_raw, distance] = myKnnsearch(descriptor1,descriptor2,knn_threshold);
[distance,idx] = sort(distance,'ascend');
matchedIP_idx = idx(~isinf(distance)); % the index of matched interest points

idx_matchedIP_img1_raw = 1:1:size(idx_matchedIP_img2_raw,2);
idx_matchedIP_img1 = idx_matchedIP_img1_raw(matchedIP_idx);
idx_matchedIP_img2 = idx_matchedIP_img2_raw(matchedIP_idx);

% remove correspondance that are not unique (which are ambiguous)
if knn_threshold ~= 1
    arr1 = getNonRepeatableElementIdx(idx_matchedIP_img1);
    arr2 = getNonRepeatableElementIdx(idx_matchedIP_img2);
    idx = intersect(arr1,arr2);
    correspondance = [idx_matchedIP_img1(idx);idx_matchedIP_img2(idx)];
    if size(correspondance,2)==0
       error('user defined error - no interest point is matched under current parameters'); 
    end
else
    correspondance = [idx_matchedIP_img1;idx_matchedIP_img2];
end

%% Compute homography matrix
% ========== Q1 3A) ==========  

% obtaining two vectors
v1 = coords1(correspondance(1,:),:);
v2 = coords2(correspondance(2,:),:);
hv1 = coords1(correspondance(1,1:4),:);
hv2 = coords2(correspondance(2,1:4),:);
h = gethmatrix(hv1, hv2);
if visualise
    figure;
    subplot(2,2,1);
    myvisualise(v1, img1, 'original corner image 1');
    subplot(2,2,2);
    myvisualise(v2, img2, 'original corner image 2');
end
projectedv2 = hmatrixproject(hv1, h);
if visualise
    subplot(2,2,[3 4]);
    myvisualise(projectedv2, img2, 'Projected coords1 on image 2');
    
    % super title displaying the values of used parameters 
    if ANMS 
        print_radius = sprintf(' suppresion radius = %d pixel',radius);
    end
    print_thre = sprintf('\n threshold for local maxima = %f',threshold);
    print_knnThre = sprintf('\n knn threshold for rejecting ambiguous matchings = %f',knn_threshold);
    suptitle_print_msg = strcat(print_radius,print_thre,print_knnThre);
    suptitle(suptitle_print_msg);

end
numberoftrial = 2000;
threshold = 0.001;
%[F,inliersIndex] = estimateFundamentalMatrix(v1, v2,'Method','RANSAC','NumTrials',500);
[bestf f2] = RansacPredictF(v1, v2, numberoftrial, threshold);
HA = calculateHA(projectedv2, hv2);
hold off;
figure;
drawEpipolarline(bestf, v1, img2);