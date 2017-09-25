function [im_out] = hybridImage(im1, im2, cutoff_low, cutoff_high)
    [m, n] = size(im1);
    
    sigma_lowpass = min(m, n) / (2 * pi * cutoff_low);
    sigma_highpass = min(m, n) / (2 * pi * cutoff_high);
    
    hsize_lowpass = 1 + round(sigma_lowpass * 6);
    hsize_highpass = 1 + round(sigma_highpass * 6);
    
    lowpass_filter = fspecial('gaussian', hsize_lowpass, sigma_lowpass);
    highpass_filter = fspecial('gaussian', hsize_highpass, sigma_highpass);
    
    im1_lowpass = imfilter(im1, lowpass_filter);
    im2_highpass = im2 - imfilter(im2, highpass_filter);
    
    % Displaying the log FT for Filtered Image
    figure();
    subplot(1,2,1);
    imagesc(log(abs(fftshift(fft2(im1_lowpass)))));
    title('im1 with Low Pass Filter');
    subplot(1,2,2);
    imagesc(log(abs(fftshift(fft2(im2_highpass)))));
    title('im2 with High Pass Filter');
    
    im_out = (im1_lowpass + im2_highpass) / 2;
end