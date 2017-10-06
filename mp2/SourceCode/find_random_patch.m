function [patch] = find_random_patch(sample, patchsize, x_range, y_range)
    x = randi(x_range);
    y = randi(y_range);
    half_size = floor(patchsize / 2);
    patch = sample(y - half_size : y + half_size, x - half_size : x + half_size, :);
end