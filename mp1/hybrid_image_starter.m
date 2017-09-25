close all; % closes all figures

% read images and convert to single format
im1 = im2single(imread('./panda.jpg'));
im2 = im2single(imread('./owl.jpg'));
im1 = rgb2gray(im1); % convert to grayscale
im2 = rgb2gray(im2);

% use this if you want to align the two images (e.g., by the eyes) and crop
% them to be of same size
[im2, im1] = align_images(im2, im1);

% Displaying Log Magnitude of Fourier Transformation for im1 and im2
figure();
suptitle('Log Magnitude of Fourier Transformation for input images');
subplot(1,2,1);
imagesc(log(abs(fftshift(fft2(im1)))));
subplot(1,2,2);
imagesc(log(abs(fftshift(fft2(im2)))));

% uncomment this when debugging hybridImage so that you don't have to keep aligning
% keyboard; 

%% Choose the cutoff frequencies and compute the hybrid image (you supply
%% this code)
arbitrary_value = 100;
cutoff_low = 10;
cutoff_high = 10; 
im12 = hybridImage(im1, im2, cutoff_low, cutoff_high);
figure; imagesc(im12);

%% Crop resulting image (optional)
figure(1), hold off, imagesc(im12), axis image, colormap gray
disp('input crop points');
[x, y] = ginput(2);  x = round(x); y = round(y);
im12 = im12(min(y):max(y), min(x):max(x), :);
figure(1), hold off, imagesc(im12), axis image, colormap gray

% Displaying Log Magnitude of Fourier Transformation for im12
figure();
suptitle('Log Magnitude of Fourier Transformation for the hybrid image');
imagesc(log(abs(fftshift(fft2(im12)))));

%% Compute and display Gaussian and Laplacian Pyramids (you need to supply this function)
N = 5; % number of pyramid levels (you may use more or fewer, as needed)
pyramids(im12, N);

