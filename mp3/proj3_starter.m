% starter script for project 3
DO_TOY = true;
DO_BLEND = true;
DO_MIXED  = true;
DO_COLOR2GRAY = true;

if DO_TOY 
    toyim = im2double(imread('./samples/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);
    disp(['Error: ' num2str(sqrt(sum((toyim(:)-im_out(:)).^2)))])
end

% do a small one first, while debugging
im_background = imresize(im2double(imread('./samples/landscape.jpg')), 1, 'bilinear');
im_object = imresize(im2double(imread('./samples/rainbow.jpg')), 1, 'bilinear');

% get source region mask from the userd
objmask = getMask(im_object);
% align im_s and mask_s with im_background
[im_s, mask_s] = alignSource(im_object, objmask, im_background);

if DO_BLEND
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3), hold off, imshow(im_blend)
end

if DO_MIXED
    im_blend = mixedBlend(im_s, mask_s, im_background);
    figure(4), hold off, imshow(im_blend);
end

if DO_COLOR2GRAY
    % also feel welcome to try this on some natural images and compare to rgb2gray
    im_rgb = im2double(imread('./samples/colorBlind4.png'));
    im_gr = color2gray(im_rgb);
    im_gray = rgb2gray(im_rgb);
    figure(5), hold off, imagesc(im_gr), axis image, colormap gray
    figure(6), hold off, imagesc(im_gray), axis image, colormap gray
    figure(7), imshow(im_rgb);
end
