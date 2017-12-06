close all;
clear;

theta = pi / 4;
l = 40;
sigma = 3;

im = im2double(imread('images/altgeld.jpg'));
sample_mask = zeros(size(im));
sample_mask = sample_mask(:, :, 1);
        
[height, width, ~] = size(im);

[Y, X] = meshgrid(1 : 30 : height, 1 : 30 : width);
X = X(:);
Y = Y(:);
to_render = randperm(length(X));

for i = 1 : length(to_render)
    im = draw_stroke(im, X(to_render(i)), Y(to_render(i)), sigma, l, theta);
%     figure(1), imshow(im);
end

figure(3), imshow(im);