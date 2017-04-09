function [] = myvisualise(coords, img, mytitle)
    imagesc(img), axis image, colormap(gray), hold on
    plot(coords(:,2),coords(:,1),'ro','LineWidth',2); 
    title(mytitle);
end