function [] = drawEpipolarline(f, v, img)
% lines = epipolarLine(f,v);
% for i = 1:size(v,1)
%    x = 1:1:size(img,1);
%    y(i,:) = (x.*lines(i,1) + lines(i,3))/ (-1.*lines(i,2));
% end
% imagesc(img), axis ([0 size(img,2) 0 size(img,1)]), colormap(gray), hold on
% for i = 1:size(v,1)
%     plot(x',y(i,:)','ro','LineWidth',0.5); 
%     title('all epipolar lines');
% end
% hold off
imagesc(img), axis ([0 size(img,2) 0 size(img,1)]), colormap(gray), hold on
epiLines = epipolarLine(f,v);
points = lineToBorderPoints(epiLines,[size(img,2),size(img,1)]);
line(points(:,[2,4])',points(:,[1,3])');
plot(v(:,2),v(:,1),'ro','LineWidth',2); 
truesize;
hold off
end