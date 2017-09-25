function [] = pyramids(im, N)
    figure();
    suptitle('Gaussian and Laplacian Pyramids');
    for i = 1:N
        [m, n] = size(im);
        im_gauss = imgaussfilt(im);
        im_lapacian = im - im_gauss;
        im = imresize(im_gauss, .5);
        subplot(2, N, i);
        imshow(im_gauss);
        subplot(2, N, i+N);
        imagesc(im_lapacian), axis off image, colormap gray;
    end
    
end