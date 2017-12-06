function im_out = draw_stroke(im, cx, cy, sigma, length, theta)

%DRAW_STROKE Draw a stroke on input image
%   Input:  im - input image
%           im_mask - mask pixels that has already been sampled
%           cx, cy - stroke center
%           radius - stroke radius
%           length - stroke length
%           theta - stroke orientation
im_out = im;

mask = lineMask(size(im), [cy + sin(theta) * length / 2 cx - cos(theta) * length /2], [cy - sin(theta) * length / 2 cx + cos(theta) * length /2], sigma);
mask(mask < 0.05) = 0;
mask(mask ~= 0) = 1;
% figure(2), imshow(mask);
stroke(:, :, 1) = mask .* im(cy, cx, 1);
stroke(:, :, 2) = mask .* im(cy, cx, 2);
stroke(:, :, 3) = mask .* im(cy, cx, 3);

im_out(stroke ~= 0) = stroke(stroke ~= 0);


end

