close all;
clear;

im_name = 'altgeld_small';

theta_base = pi / 4;
l_base = 4;
sigma_base = 0.5;
edge_threshold = 0.2;

im = im2double(imread(strcat('images/', im_name, '.jpg')));

im_grayscale = rgb2gray(im);
im_grayscale = imgaussfilt(im_grayscale, 2);
im_edge = edge(im_grayscale, 'canny');
[Gmag,Gdir] = imgradient(im_grayscale);
Gdir = imgaussfilt(Gdir, 2);
im = imgaussfilt(im, 0.8);

figure(), imshow(im);
figure(), imshow(Gmag);
figure(), imagesc(Gdir);

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
    
    l = l_base + randi([0 6]);
    
    sigma = sigma_base + randi([-50 50]) / 1000;
    
    if(Gdir(cy, cx) < 0)
        theta = (Gdir(cy, cx) + 180) / 360 * 2 * pi;
    else
        theta = Gdir(cy, cx) / 360 * 2 * pi;
    end
    
    theta = theta - pi / 2;
    
    if(theta > - pi / 2 + 0.1 && theta < pi / 2 - 0.1)
        xrange = abs(l / 2 * cos(theta));

        left = 0;
        while left < xrange
            y = round(cy - left * tan(theta));
            x = cx - left;
            if(y <= 1 || y >= height || x <= 1 || x >= width)
                break;
            end
            if(Gmag(y, x) > edge_threshold || Gmag(y, x + 1) > edge_threshold || Gmag(y - 1, x + 1) > edge_threshold || Gmag(y + 1, x + 1) > edge_threshold || Gmag(y - 1, x) > edge_threshold || Gmag(y + 1, x) > edge_threshold || Gmag(y, x - 1) > edge_threshold || Gmag(y + 1, x - 1) > edge_threshold || Gmag(y - 1, x - 1) > edge_threshold)
                break;
            end
            left = left + 1;
        end

        right = 0;
        while right < xrange
            y = round(cy + right * tan(theta));
            x = cx + right;
            if(y <= 1 || y >= height || x <= 1 || x >= width)
                break;
            end
            if(Gmag(y, x) > edge_threshold || Gmag(y, x + 1) > edge_threshold || Gmag(y - 1, x + 1) > edge_threshold || Gmag(y + 1, x + 1) > edge_threshold || Gmag(y - 1, x) > edge_threshold || Gmag(y + 1, x) > edge_threshold || Gmag(y, x - 1) > edge_threshold || Gmag(y + 1, x - 1) > edge_threshold || Gmag(y - 1, x - 1) > edge_threshold)
                break;
            end
            right = right + 1;
        end

        l = abs(round((right + left) / cos(theta)));
    else
        gamma = pi / 2 - theta;
        yrange = abs(l / 2 * cos(gamma));
        up = 0;
        while up < yrange
            y = cy + up;
            x = round(cx - up * tan(gamma));
            if(y <= 1 || y >= height || x <= 1 || x >= width)
                break;
            end
            if(Gmag(y, x) > edge_threshold || Gmag(y, x + 1) > edge_threshold || Gmag(y - 1, x + 1) > edge_threshold || Gmag(y + 1, x + 1) > edge_threshold || Gmag(y - 1, x) > edge_threshold || Gmag(y + 1, x) > edge_threshold || Gmag(y, x - 1) > edge_threshold || Gmag(y + 1, x - 1) > edge_threshold || Gmag(y - 1, x - 1) > edge_threshold)
                break;
            end
            up = up + 1;
        end
        
        down = 0;
        while down < yrange
            y = cy - down;
            x = round(cx + down * tan(gamma));
            if(y <= 1 || y >= height || x <= 1 || x >= width)
                break;
            end
            if(Gmag(y, x) > edge_threshold || Gmag(y, x + 1) > edge_threshold || Gmag(y - 1, x + 1) > edge_threshold || Gmag(y + 1, x + 1) > edge_threshold || Gmag(y - 1, x) > edge_threshold || Gmag(y + 1, x) > edge_threshold || Gmag(y, x - 1) > edge_threshold || Gmag(y + 1, x - 1) > edge_threshold || Gmag(y - 1, x - 1) > edge_threshold)
                break;
            end
            down = down + 1;
        end 
        
        l = (up + down) * cos(gamma);
    end
    
    im_out = draw_stroke(im_out, color, cx, cy, sigma, l, theta);
end

figure(), imshow(im_out);
imwrite(im_out, strcat(im_name , '_gradient_stroke.jpg'));