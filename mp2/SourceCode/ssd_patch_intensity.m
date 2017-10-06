function [im_cost] = ssd_patch_intensity(sample, mask, template, x_range, y_range, alpha, target_patch)

    sample_gray = im2double(rgb2gray(sample));
    
    sample1 = sample(:, :, 1);
    sample2 = sample(:, :, 2);
    sample3 = sample(:, :, 3);
    mask1 = mask(:, :, 1);
    mask2 = mask(:, :, 2);
    mask3 = mask(:, :, 3);
    template1 = template(:, :, 1);
    template2 = template(:, :, 2);
    template3 = template(:, :, 3);
    ssd_overlap(:, :, 1) = imfilter(sample1 .^ 2, mask1) - 2 * imfilter(sample1, mask1 .* template1) + sum(sum((mask1 .* template1) .^ 2));
    ssd_overlap(:, :, 2) = imfilter(sample2 .^ 2, mask2) - 2 * imfilter(sample2, mask2 .* template2) + sum(sum((mask2 .* template2) .^ 2));
    ssd_overlap(:, :, 3) = imfilter(sample3 .^ 2, mask3) - 2 * imfilter(sample3, mask3 .* template3) + sum(sum((mask3 .* template3) .^ 2));
    
    ssd_overlap = ssd_overlap(y_range(1) : y_range(2), x_range(1) : x_range(2));
    
    mask = ones(size(target_patch));
    
    ssd_transfer = imfilter(sample_gray .^ 2,  mask) - 2 * imfilter(sample_gray, mask .* target_patch) + sum(sum((mask .* target_patch) .^ 2));
    
    ssd_transfer = ssd_transfer(y_range(1) : y_range(2), x_range(1) : x_range(2));
    
    im_cost = alpha * ssd_overlap + (1 - alpha) * ssd_transfer;

end