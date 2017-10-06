function [im_cost] = ssd_patch(sample, mask, template, x_range, y_range)
    sample1 = sample(:, :, 1);
    sample2 = sample(:, :, 2);
    sample3 = sample(:, :, 3);
    mask1 = mask(:, :, 1);
    mask2 = mask(:, :, 2);
    mask3 = mask(:, :, 3);
    template1 = template(:, :, 1);
    template2 = template(:, :, 2);
    template3 = template(:, :, 3);
    im_cost(:, :, 1) = imfilter(sample1 .^ 2, mask1) - 2 * imfilter(sample1, mask1 .* template1) + sum(sum((mask1 .* template1) .^ 2));
    im_cost(:, :, 2) = imfilter(sample2 .^ 2, mask2) - 2 * imfilter(sample2, mask2 .* template2) + sum(sum((mask2 .* template2) .^ 2));
    im_cost(:, :, 3) = imfilter(sample3 .^ 2, mask3) - 2 * imfilter(sample3, mask3 .* template3) + sum(sum((mask3 .* template3) .^ 2));
    im_cost = im_cost(y_range(1) : y_range(2), x_range(1) : x_range(2));
end