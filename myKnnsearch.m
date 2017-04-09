function [index, distance] = myKnnsearch(X,Y,threshold)
% returns inf if corresponding descriptor not matched
%Q1 Automatic
%2C) performs Knn
    x_size = size(X,1);
    y_size = size(Y,1);
    for i = 1:x_size
        tmp_distance = [];
        for j = 1:y_size
            tmp_distance(j) = sum(abs(X(i,:)-Y(j,:)));
        end
        
        % ======== features have poor discriminality ===============
        % So we propose a method to reject ambiguously matched descriptors 
        % by adding a threshold 
        % Note that ***** this method doesn't work well in two situations:
        %       1. Interest points are too dense.
        %       2. Small number of repeatable interest points.
        [value, idx] = sort(tmp_distance,'ascend');
        min_v = value(1);
        snd_min_v = value(2);
        if min_v > (snd_min_v/threshold)
            min_v = inf; %indicating corresponding descriptor not matched
        end
        
        
        
        distance(i) = min_v;
        index(i) = idx(1);
    end
    
    
    
    
%remove outlier
%eliminateindex = [];
%for i = 1:size(index, 1)
%    if(distance(i)>0.08)
%        eliminateindex(end+1) = i;
%    end
%end
%index(eliminateindex,:)=[];
%distance(eliminateindex,:)=[];

end