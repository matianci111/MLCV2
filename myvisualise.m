function [] = myvisualise(coords, img, num_of_strongest_corners, mytitle)
    show_corner = [];
    num_of_corners=size(coords,1);
    if num_of_corners > num_of_strongest_corners %the number of corners
        figure, imagesc(img), axis image, colormap(gray), hold on
        plot(coords(1:num_of_strongest_corners,2),coords(1:num_of_strongest_corners,1),'ys'), title('corners detected');
    else
        loop_size=num_of_corners;
        figure, imagesc(img), axis image, colormap(gray), hold on
        plot(coords(:,2),coords(:,1),'ys'), title(mytitle);
    end
end