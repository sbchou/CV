function labeled_img = generateLabeledImage(gray_img, threshold)
    %threshold of 0.5 works best

    img = imread(gray_img);
    imshow(img); title('Original Image');

    %bw_img = im2bw(img, threshold);
    bw_img = zeros(size(img));
    ind = find(img > 255 * threshold);
    bw_img(ind) = img(ind);
    
    imshow(bw_img); title('BW IMAGE');

    labeled_img = bwlabel(bw_img, 4);
    %for debugging 
    m = max(labeled_img(:))
    % display with different colors (for debug)
    RGB = label2rgb(labeled_img);
    imshow(RGB)

end