close all;
clear;

theta_base = pi / 4;
l_base = 4;
sigma_base = 0.5;

im = im2double(imread('images/altgeld_small.jpg'));
sample_mask = zeros(size(im));
sample_mask = sample_mask(:, :, 1);
        
[height, width, ~] = size(im);
im_out = zeros(size(im));

[Y, X] = meshgrid(1 : 2 : height, 1 : 2 : width);
X = X(:);
Y = Y(:);
to_render = randperm(length(X));

for i = 1 : length(to_render)
    disp(i / length(to_render) * 100);
    
    cx = X(to_render(i));
    cy = Y(to_render(i));
    color = im(cy, cx, :) .* randi([85 115]) ./ 100;
    
    sigma = sigma_base + randi([-50 50]) / 1000;
    l = l_base + randi([0 6]);
    theta = theta_base + randi([-15 15]) / 360 * 2 * pi;
    
    im_out = draw_stroke(im_out, color, cx, cy, sigma, l, theta);
end

figure(3), imshow(im_out);
imwrite(im_out, 'random_perturbation.jpg');