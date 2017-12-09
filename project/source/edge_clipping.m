close all;
clear;

im_name = 'altgeld_small';

theta_base = pi / 4;
l_base = 4;
sigma_base = 0.5;

im = im2double(imread(strcat('images/', im_name, '.jpg')));
      
im_grayscale = rgb2gray(im);
im_grayscale = imgaussfilt(im_grayscale);
[Gmag,Gdir] = imgradient(im_grayscale);

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
    theta = theta_base + randi([-15 15]) / 360 * 2 * pi;
    l = l_base + randi([0 6]);
    xrange = l / 2 * cos(theta);
    
    left = 0;
    while left < xrange
        left = left + 1;
        y = round(cy - left * tan(theta));
        x = cx - left;
        if(y <= 1 || y >= height || x <= 1 || x >= width)
            break;
        end
        if(Gmag(y, x) ~= 0 || Gmag(y, x + 1) ~= 0 || Gmag(y - 1, x + 1) ~= 0 || Gmag(y + 1, x + 1) ~= 0 || Gmag(y - 1, x) ~= 0 || Gmag(y + 1, x) ~= 0 || Gmag(y, x - 1) ~= 0 || Gmag(y + 1, x - 1) ~= 0 || Gmag(y - 1, x - 1) ~= 0)
            break;
        end
    end
    
    right = 0;
    while right < xrange
        right = right + 1;
        y = round(cy + right * tan(theta));
        x = cx + right;
        if(y <= 1 || y >= height || x <= 1 || x >= width)
            break;
        end
        if(Gmag(y, x) ~= 0 || Gmag(y, x + 1) ~= 0 || Gmag(y - 1, x + 1) ~= 0 || Gmag(y + 1, x + 1) ~= 0 || Gmag(y - 1, x) ~= 0 || Gmag(y + 1, x) ~= 0 || Gmag(y, x - 1) ~= 0 || Gmag(y + 1, x - 1) ~= 0 || Gmag(y - 1, x - 1) ~= 0)
            break;
        end
    end
    
    l = (right + left) / cos(theta);
    im_out = draw_stroke(im_out, color, cx, cy, sigma, l, theta);
end

figure(3), imshow(im_out);
imwrite(im_out, strcat(im_name , '_edge_clipping.jpg'));