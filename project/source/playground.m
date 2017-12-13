close all;
clear;
im = im2double(imread('images/altgeld_small.jpg'));
im_grayscale = rgb2gray(im);
imwrite(im_grayscale, 'altgeld_small_grayscale.jpg');
im_grayscale = imgaussfilt(im_grayscale);
imwrite(im_grayscale, 'altgeld_small_grayscale_low_pass.jpg');
figure(11), imshow(im_grayscale);
im_edge = edge(im_grayscale, 'sobel');
imwrite(im_edge, 'altgeld_small_sobel_edge.jpg');
edge_threshold = 0.2;

[Gmag,Gdir] = imgradient(im_grayscale);
[D, Idx] = bwdist(Gmag > edge_threshold);
figure, imagesc(Gmag);
figure, imagesc(Gdir);
[height, width, ~] = size(im);
for i = 1 : height
    for j = 1 : width
        if(Gmag(i, j) < edge_threshold)
            Gdir(i, j) = Gdir(mod(Idx(i, j), height) + 1, min(floor((Idx(i, j) - 1) / height) + 1, width));
        end
    end
end
figure, imagesc(Gdir);


