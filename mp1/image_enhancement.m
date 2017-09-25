close all;
%% contrast enhancement
% read image1
im1 = imread('dark.jpg');
im1 = im2double(im1);

% display the original image1
figure();
imshow(im1);
title('Original Image1');

% contrast enhancement using gamma correction
gamma = 0.4;
im_contrast_enhanced = im1 .^ gamma;
figure();
imshow(im_contrast_enhanced);
title('Contrast Enhancement with Gamma Correction for Image1');

%% color enhancement
% read image2
im2 = imread('color.jpg');
im2 = im2double(im2);

% display the original image2
figure();
imshow(im2);
title('Original Image2');

% color enhancement by taking square root of original saturation values
% values in s are mapped into [0,1]. Then taking square roots of these value will increase 
% the overall saturation of the original image and new saturation values will still be 
% mapped into [0, 1]. Once the overall saturation of an image is increased,
% its color will be brighter.
[h, s, v] = rgb2hsv(im2);
im_color_enhanced = cat(3, h, s .^ 0.5, v);
im_color_enhanced = hsv2rgb(im_color_enhanced);
figure();
imshow(im_color_enhanced);
title('Color Enhancement by Taking Square Roots of Saturation Values of Image2');

%% color shift
% Since we are going to make a image more red and less yellow, we should
% convert the image into lab format and change a and b.
im3 = imread('yellowish.png');
im3 = im2double(im3);
[l, a, b] = rgb2lab(im3);

% display the original image3
figure();
imshow(im3);
title('Original Image3');

% make it more read
im_more_red = cat(3, l, a + 20, b);
im_more_red = lab2rgb(im_more_red);
figure();
imshow(im_more_red);
title('More Red');

% make it less yellow
im_less_yellow = cat(3, l, a, b - 20);
im_less_yellow = lab2rgb(im_less_yellow);
figure();
imshow(im_less_yellow);
title('Less Yellow');
