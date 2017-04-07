function y = hmatrixproject(x, v)
x_size = size(x,1);
for i = 1:x_size
   tmp=v*[x(i,:),1]'; 
   q = tmp(3,:);
   y(i,:) = [tmp(1,:)./q tmp(2,:)./q];
end
end