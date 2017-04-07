function [index distance] = myKnnsearch(X,Y)
%Q1 Automatic
%2C) performs Knn
    x_size = size(X,1);
    y_size = size(Y,1);
    
    for i = 1:x_size
        for j = 1:y_size
            tmp_distance(j) = sum(abs(X(i,:)-Y(j,:)));
        end
        [value, idx] = min(tmp_distance);
        distance(i) = value;
        index(i) = idx;
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