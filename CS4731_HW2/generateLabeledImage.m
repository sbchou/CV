function labeled_img = generateLabeledImage(gray_img, threshold)

img = imread(gray_img);
imshow(img); title('Original Image');

% Convert the image into a binary image by applying a threshold
%threshold = 0.5;

bw_img = im2bw(img, threshold);
imshow(bw_img); title('BW IMAGE');

labeled_img = bwlabel(bw_img, 4);
m = max(labeled_img(:))
