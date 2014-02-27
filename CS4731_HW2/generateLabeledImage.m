function labeled_img = generateLabeledImage(gray_img, threshold)
    %threshold of 0.5 works best

    imshow(gray_img); title('Original Image');

    %bw_img = im2bw(img, threshold);
    bw_img = zeros(size(gray_img));
    ind = find(gray_img > 255 * threshold);
    bw_img(ind) = gray_img(ind);
    
    imshow(bw_img); title('BW IMAGE');

    labeled_img = bwlabel(bw_img, 4);
    %for debugging 
    m = max(labeled_img(:))
    % display with different colors (for debug)
    RGB = label2rgb(labeled_img);
    imshow(RGB)

end