close all;
clear;
im = im2double(imread('images\apple_small.jpg'));
subplot(1, 2, 1);
imshow(im);
im_grayscale = rgb2gray(im);
im_grayscale = imgaussfilt(im_grayscale);
im_edge = edge(im_grayscale, 'sobel');
subplot(1, 2, 2);
imshow(im_edge);
[Gmag,Gdir] = imgradient(im_grayscale);
figure, imshow(Gmag, []), title('Gradient magnitude')
figure, imshow(Gdir, []), title('Gradient direction')