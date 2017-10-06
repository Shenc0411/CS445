close all; % closes all figures

rng('shuffle');

sample = imread('resources/sketch.tiff');

figure();
imshow(sample);
title('Texture Sample');

outsize = [512, 512];
patchsize = 63;

[input_height, input_width, num_channels] = size(sample);

random_quilt_result = quilt_random(sample, outsize, patchsize);
figure();
imshow(random_quilt_result);
title('Quilt by Picking Random Patches from the Sample');

outsize = [512, 512];
overlap = 8;
tolerence = 0.01;
% 
% simple_quilt_result = quilt_simple(sample, outsize, patchsize, overlap, tolerence);
% figure();
% imshow(simple_quilt_result);
% title('Quilt by Picking Overlapping Patches');

% seam_finding_quilt_result = quilt_cut(sample, outsize, patchsize, overlap, tolerence);
% figure();
% imshow(seam_finding_quilt_result);
% title('Quilt by Using Seam Finding');
%  

sample = imread('resources/sketch.tiff');
target = imread('resources/feynman.tiff');
figure();
imshow(target);
patchsize = 15;
overlap = 4;
alpha = 0.6;
 
texture_transfer_result = texture_transfer(sample, target, patchsize, overlap, tolerence, alpha);
figure();
imshow(texture_transfer_result);
title('Texture Transfer');